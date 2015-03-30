//
//  Timelog.m
//  asg
//
//  Created by Rey Jenald Peña on 3/26/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "Timelog.h"

@implementation Timelog
@dynamic workArea;
@dynamic workSite;
@dynamic checkInTime;
@dynamic user;
@dynamic checkOutTime;

+ (NSString *)parseClassName {
    return @"Timelog";
}

@end
