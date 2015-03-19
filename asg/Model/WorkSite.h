//
//  WorkSite.h
//  asg
//
//  Created by Rey Jenald Peña on 2/27/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <Parse/Parse.h>


@interface WorkSite : PFObject <PFSubclassing>
+ (NSString *)parseClassName;
@property (retain) NSString *name;
@property (retain) NSString *address;
@property (retain) NSString *description;
@property (retain) NSString *code;
@property (retain) PFFile *image;
@property (retain) PFUser *user;

@end
