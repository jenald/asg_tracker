//
//  Global.h
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class Timelog;
typedef void(^myCompletion)(BOOL);

@interface Global : NSObject
@property (assign) BOOL isManager;
@property (assign) BOOL isCheckedIn;
@property (retain) Timelog *timelog;
+ (id)sharedInstance;
+ (UIViewController *)loadViewControllerFromStoryboardIdentifier:(NSString *)identifier;
+ (BOOL)isValidEmailString:(NSString *)emailString;
+ (void)isCurrentUserManager:(myCompletion)completion;
- (void)checkUserTimeInStatus;

@end
