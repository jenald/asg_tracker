//
//  Asset.m
//  asg
//
//  Created by Rey Jenald Pena on 4/8/15.
//  Copyright (c) 2015 appfibre. All rights reserved.
//

#import "Asset.h"

@implementation Asset
@dynamic number;
@dynamic model;
@dynamic manufacturer;
@dynamic type;
@dynamic inspectionDate;
@dynamic expiryDate;
@dynamic purchaseDate;
@dynamic code;
@dynamic name;
@dynamic status;
@dynamic image;

+ (NSString *)parseClassName {
    return @"Asset";
}

@end
