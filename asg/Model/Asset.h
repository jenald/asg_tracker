//
//  Asset.h
//  asg
//
//  Created by Rey Jenald Pena on 4/8/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import <Parse/Parse.h>

@interface Asset : PFObject <PFSubclassing>
+ (NSString *)parseClassName;
@property (retain) NSString *number;
@property (retain) NSString *model;
@property (retain) NSString *type;
@property (retain) NSString *manufacturer;
@property (retain) NSString *code;
@property (retain) NSString *name;
@property (assign) BOOL status;
@property (retain) PFFile *image;
@property (retain) NSDate *inspectionDate;
@property (retain) NSDate *expiryDate;
@property (retain) NSDate *purchaseDate;

@end
