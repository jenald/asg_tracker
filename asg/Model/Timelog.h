//
//  Timelog.h
//  asg
//
//  Created by Rey Jenald Peña on 3/26/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <Parse/Parse.h>

@class WorkSite,WorkArea, PFUser;

@interface Timelog : PFObject <PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) WorkArea *workArea;
@property (retain) WorkSite *workSite;
@property (retain) NSDate *checkInTime;
@property (retain) PFUser *user;
@property (retain) NSDate *checkOutTime;

@end
