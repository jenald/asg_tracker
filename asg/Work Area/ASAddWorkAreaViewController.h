//
//  ASAddWorkAreaViewController.h
//  asg
//
//  Created by Rey Jenald Pena on 3/12/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkSite,WorkArea;
@interface ASAddWorkAreaViewController : UIViewController
@property (nonatomic, weak) WorkSite *worksite;
@property (nonatomic, weak) WorkArea *workarea;
@end
