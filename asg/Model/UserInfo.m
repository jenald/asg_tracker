//
//  UserInfo.m
//  asg
//
//  Created by Rey Jenald Peña on 2/23/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "UserInfo.h"
#import <Parse/PFSubclassing.h>

@implementation UserInfo
@dynamic fullName;
@dynamic idNumber;
@dynamic phoneNumber;
@dynamic user;
@dynamic manager;
@dynamic position;

+ (NSString *)parseClassName {
    return @"UserInfo";
}

@end
