//
//  ASDetailsWorkAreaViewController.h
//  asg
//
//  Created by Rey Jenald Pena on 3/13/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkArea, WorkSite;
@interface ASDetailsWorkAreaViewController : UIViewController
@property (nonatomic, weak) WorkArea *workarea;
@property (nonatomic, weak) WorkSite *worksite;

@end
