//
//  Position.h
//  asg
//
//  Created by Rey Jenald Peña on 2/24/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <Parse/Parse.h>

@interface Position : PFObject <PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString *name;
@property (retain) NSString *positionId;

@end
