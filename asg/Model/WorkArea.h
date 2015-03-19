//
//  WorkArea.h
//  asg
//
//  Created by Rey Jenald Pena on 3/12/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <Parse/Parse.h>

@class WorkSite;

@interface WorkArea : PFObject <PFSubclassing>
+ (NSString *)parseClassName;
@property (retain) NSString *name;
@property (retain) NSString *address;
@property (retain) NSString *status;
@property (retain) NSNumber *code;
@property (retain) PFFile *image;
@property (retain) WorkSite *worksite;

@end
