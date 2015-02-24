//
//  UserInfo.h
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <Parse/Parse.h>

@class PFUser,Position;

@interface UserInfo : PFObject <PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString *fullName;
@property (retain) NSString *idNumber;
@property (retain) NSString *phoneNumber;
@property (retain) PFUser *user;
@property (retain) Position *position;

@end
