//
//  WorkArea.m
//  asg
//
//  Created by Rey Jenald Pena on 3/12/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "WorkArea.h"
#import "WorkSite.h"

@implementation WorkArea
@dynamic name;
@dynamic address;
@dynamic status;
@dynamic code;
@dynamic image;
@dynamic worksite;

+ (NSString *)parseClassName {
    return @"WorkArea";
}
@end
