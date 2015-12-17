//
//  ViewController.m
//  SliceMenu
//
//  Created by MOSTEFAOUI Anas on 13/12/15.
//  Copyright © 2015 applinova. All rights reserved.
//

#import "SliceMenuHostViewController.h"
#import "SliceMenuViewController.h"

@interface SliceMenuHostViewController (){
 
#ifdef DEBUG
    
    // Visual Helpers
    UIView* offsetView ;
    UIView* anchorView ;
#endif
    UIOffset attachmentPoint ;
}

@end

@implementation SliceMenuHostViewController


float initialRotation = -90;
int headerPadding = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  Setup the menu by passing a UIViewController to it
 *
 *  @param menu Menu view controller
 */
- (void)setupMenuWithView:(SliceMenuViewController*)menu  {
    _Menu = menu;//[self.storyboard instantiateViewControllerWithIdentifier:@"SliceMenu"];
    if(_Menu !=nil){
         [self.view addSubview:_Menu.view];
        _Menu.delegate = self;
        _menuView = _Menu.view;
    }


    [self prepareHeaderPaddingSize];
    [self initAnimation];


#ifdef DEBUG
    // this is used to track "center" property changes, to update the view
    [_menuView addObserver:self forKeyPath:NSStringFromSelector(@selector(center)) options:NSKeyValueObservingOptionNew context:NULL];
#endif

}

/**
 *  setup the top padding value of header
 */
-(void) prepareHeaderPaddingSize{
    navBarH = _HeaderSize;
    statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    headerPadding = (int) (navBarH+statusBarH);
}


-(void) prepareAnimator:(UIOffset)theAttachmentPoint withAnchorPoint:(CGPoint)theAnchorPointParam{
    theAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    theAnimator.delegate = self;
    
    attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:_menuView offsetFromCenter:theAttachmentPoint attachedToAnchor:theAnchorPointParam];
    
    collision = [[UICollisionBehavior alloc]initWithItems:@[_menuView]];

    pushInit = [[UIPushBehavior alloc] initWithItems:@[_menuView] mode:UIPushBehaviorModeContinuous];


    itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[_menuView]];
    itemBehaviour.elasticity = 0.5;
    itemBehaviour.resistance = 0.5;
    itemBehaviour.allowsRotation = YES;
}

/**
 *  Rotate the menu, to take correct initial position without animation.
 */
-(void) prepareMenu{
    
    // first, rotate the menu, to avoid animating it to take initial position
    [_menuView.layer setAnchorPoint:CGPointMake(0.1, 0.1)];
    _menuView.transform = CGAffineTransformRotate(_menuView.transform, (CGFloat) ((initialRotation/180)* M_PI));
    
    // rotation done, bring back anchor point of this view to center.
    [_menuView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    // make sur view are correctly positioned
    _menuView.frame = CGRectMake(0, -_menuView.frame.size.height+headerPadding, _menuView.frame.size.width, _menuView.frame.size.height);

}


-(void) initAnimation{

     CGPoint theAnchorPoint  = [self generateAnchorPointFromView:nil];// CGPointMake(33,33);
    
     attachmentPoint = UIOffsetMake(-_menuView.bounds.size.width/2+theAnchorPoint.x,-_menuView.bounds.size.height/2+theAnchorPoint.y);
    
    // rotate the menu
    [self prepareMenu];
    
    // creat animator and behaviours
    [self prepareAnimator:attachmentPoint withAnchorPoint:theAnchorPoint];
    

#ifdef DEBUG
    // visual helper
    anchorView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 16, 16)];
    anchorView.center = attachmentBehavior.anchorPoint;
    anchorView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:anchorView];
    
    // UIOffset offsetFromScreenCenter = UIOffsetMake(-_menuView.bounds.size.height/2 , -_menuView.bounds.size.width/2);
    
    
    if(offsetView==nil)
        offsetView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 6, 6)];
    
    offsetView.center = _menuView.center;   // offsetView.frame = CGRectOffset(offsetView.frame, offset.horizontal, offset.vertical);
    offsetView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:offsetView];
    
#endif
}

/**
 *  get anchor point from the center of a view, if not available, use MenuRotationAnchorPoint inspectable property
 *
 *  @param view view to be anchored to
 *
 *  @return anchor point
 */
-(CGPoint) generateAnchorPointFromView:(UIView*)view{
  return view==nil ? CGPointMake(headerPadding /2, headerPadding /2):view.center;
}

#pragma mark - Menu state changing handling

- (IBAction)Open:(id)sender {
        [self menuChangeState:_Menu isOpen:YES];
}

-(void)openMenu{

    // add left boundry, when we open the menu
        [collision addBoundaryWithIdentifier:@"left" fromPoint:CGPointMake(-1,self.view.frame.size.height/2) toPoint:CGPointMake(-1, self.view.frame.size.height)];

    // add force and behaviours, they were removed when animator did pause
        CGVector direction = CGVectorMake(0, _Velocity);
        pushInit.pushDirection = direction;
        [theAnimator addBehavior:collision];
        [theAnimator addBehavior:attachmentBehavior];
        [theAnimator addBehavior:pushInit];
    
        [theAnimator addBehavior:itemBehaviour];
}

-(void) closeMenu{
   
    [collision addBoundaryWithIdentifier:@"top" fromPoint:CGPointMake(self.view.frame.size.height/2,-self.view.frame.size.width+headerPadding) toPoint:CGPointMake(self.view.frame.size.height,-self.view.frame.size.width+headerPadding)];
    
    /*
    collisionBehaviour.addBoundaryWithIdentifier("collide",
                                                 fromPoint: CGPointMake(containerFrame.height/2, -containerFrame.width+statusbarHeight+navigationBarHeight),
                                                 toPoint: CGPointMake(containerFrame.height, -containerFrame.width+statusbarHeight+navigationBarHeight)
                                                 */
    
     CGVector direction = CGVectorMake(0, -_Velocity);
    pushInit.pushDirection = direction;
    
        [theAnimator addBehavior:collision];
    [theAnimator addBehavior:attachmentBehavior];
    [theAnimator addBehavior:pushInit];
    
    [theAnimator addBehavior:itemBehaviour];
}


/**
 *  Delegate handling menu state modification
 *
 *  @param menu      menu
 *  @param openState new menu state
 */
-(void)menuChangeState:(UIViewController *)menu isOpen:(BOOL)openState{
    isOpen = openState;
    if(isOpen){
        [self openMenu];
    }
    else{
        [self closeMenu];
    }
}

-(BOOL)getMenuState{
    return isOpen;
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    
    if(isOpen) {
        // clean everything : reset transform, bound, and remove behaviors to stop any action
        [animator removeAllBehaviors];
        _menuView.transform = CGAffineTransformIdentity;
        _menuView.frame = self.view.bounds;
    }
    else{
        [animator removeAllBehaviors];
    }

}

#ifdef DEBUG

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if([keyPath isEqualToString:@"center"]){
        CGPoint o = CGPointMake(_menuView.center.x+attachmentPoint.horizontal, _menuView.center.y+attachmentPoint.vertical);
        offsetView.center = o;
    }
}

#endif


@end
