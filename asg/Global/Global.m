//
//  Global.m
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "Global.h"
#import <Parse/Parse.h>
#import "UserInfo.h"
#import "Position.h"
#import "Timelog.h"

@implementation Global

static Global *sharedMyManager = nil;

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.isManager = NO;
        self.isCheckedIn = NO;
    }
    return self;
}

+ (UIViewController *)loadViewControllerFromStoryboardIdentifier:(NSString *)identifier {
    
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
    
    return controller;
}

+ (BOOL)isValidEmailString:(NSString *)emailString {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

+ (void)isCurrentUserManager:(myCompletion)completion {
    if ([PFUser currentUser]) {
        PFQuery *userInfoQuery = [UserInfo query];
        [userInfoQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        [userInfoQuery includeKey:@"position"];
        NSArray *objects =  [userInfoQuery findObjects];
        if (objects.count > 0) {
            UserInfo *userInfo = (UserInfo *)[objects firstObject];
            Position *position = (Position *)[userInfo objectForKey:@"position"];
            if ([[position objectForKey:@"positionId"]  isEqual: @(1)]) {
                completion(YES);
            } else {
                completion(NO);
            }
        } else {
            completion(NO);
        }
    } else {
        completion(NO);
    }
}

- (void)checkUserTimeInStatus {
    PFQuery *query = [Timelog query];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"checkOutTime" equalTo:[NSNull null]];
    [query includeKey:@"workSite"];
    [query includeKey:@"workArea"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                self.timelog = [objects firstObject];
                self.isCheckedIn = YES;
            } else {
                self.isCheckedIn = NO;
            }
        } else {
            
        }
    }];
}

@end
