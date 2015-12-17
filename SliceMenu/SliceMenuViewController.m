//
//  SliceMenuViewController.m
//  SliceMenu
//
//  Created by MOSTEFAOUI Anas on 13/12/15.
//  Copyright © 2015 applinova. All rights reserved.
//

#import "SliceMenuViewController.h"


@implementation SliceMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)MenuSwitchState:(id)sender {
    
    if(_delegate!=nil){
        [_delegate menuChangeState:self isOpen:NO];
    }
}


-(BOOL) isMenuOpen{
    if(_delegate!=nil){
        return [_delegate getMenuState];
    }
    else{
        return NO;
    }
}

@end
