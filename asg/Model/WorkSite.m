//
//  WorkSite.m
//  asg
//
//  Created by Rey Jenald Peña on 2/27/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "WorkSite.h"

@implementation WorkSite
@dynamic name;
@dynamic address;
@dynamic description;
@dynamic code;
@dynamic image;
@dynamic user;

+ (NSString *)parseClassName {
    return @"WorkSite";
}

@end
