//
//  NSDate+ASAdditions.m
//  asg
//
//  Created by Rey Jenald Pena on 3/30/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "NSDate+ASAdditions.h"

@implementation NSDate (ASAdditions)
- (NSString *)stringWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    NSString *stringFromDate = [formatter stringFromDate:self];
    
    return stringFromDate;
}

@end
