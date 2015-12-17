//
//  ViewController.h
//  SliceMenu
//
//  Created by MOSTEFAOUI Anas on 13/12/15.
//  Copyright © 2015 applinova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliceMenuDelegate.h"


@class SliceMenuViewController;


@interface SliceMenuHostViewController : UIViewController<SliceMenuDelegate, UIDynamicAnimatorDelegate>
{

    float navBarH;
    float statusBarH;
    BOOL isOpen;

    UIPushBehavior *pushInit;
    UIAttachmentBehavior *attachmentBehavior;
    UIDynamicItemBehavior* itemBehaviour;

    // - Dynamics
    UIDynamicAnimator   *theAnimator;
    UICollisionBehavior *collision;

}

@property (nonatomic) IBInspectable int Velocity;
@property (nonatomic) IBInspectable int HeaderSize;

@property(nonatomic) IBOutlet SliceMenuViewController* Menu;

@property (weak, nonatomic) IBOutlet UIView *menuView;

- (void)setupMenuWithView:(SliceMenuViewController*)menu;

@end

