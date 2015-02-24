//
//  Global.h
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Global : NSObject
+ (UIViewController *)loadViewControllerFromStoryboardIdentifier:(NSString *)identifier;
+ (BOOL)isValidEmailString:(NSString *)emailString;

@end
