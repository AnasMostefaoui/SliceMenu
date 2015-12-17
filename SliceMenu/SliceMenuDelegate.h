//
//  SliceMenuDelegate.h
//  SliceMenu
//
//  Created by MOSTEFAOUI Anas on 16/12/15.
//  Copyright © 2015 applinova. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SliceMenuDelegate <NSObject>

-(void) menuChangeState:(UIViewController*)menu isOpen:(BOOL)openState;
-(BOOL) getMenuState;
@end
