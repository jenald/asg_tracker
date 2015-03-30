//
//  NSDate+ASAdditions.m
//  asg
//
//  Created by Rey Jenald Pena on 3/30/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "NSDate+ASAdditions.h"

@implementation NSDate (ASAdditions)
- (NSString *)getMonthDayYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, YYYY EEEE"];
    
    NSString *stringFromDate = [formatter stringFromDate:self];
    
    return stringFromDate;
}

@end
