//
//  KHVCInfoPathItem.m
//  KHVCInfo
//
//  Created by Kent Humphries on 22/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "KHVCInfoPathItem.h"

@implementation KHVCInfoPathItem

- (instancetype)initWithName:(NSString*)name nextItemRelationship:(NSString*)nextItemRelationship
{
    self = [super init];
    if (self)
    {
        _name = name;
        _nextItemRelationship = nextItemRelationship;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ (%@)",self.name, self.nextItemRelationship];
}

@end
