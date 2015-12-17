//
//  SliceMenuViewController.h
//  SliceMenu
//
//  Created by MOSTEFAOUI Anas on 13/12/15.
//  Copyright © 2015 applinova. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "SliceMenuDelegate.h"


@interface SliceMenuViewController : UIViewController<UITableViewDelegate>{
}

@property (nonatomic, weak) id<SliceMenuDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *BackButton;


@end
