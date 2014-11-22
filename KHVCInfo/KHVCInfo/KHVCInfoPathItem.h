//
//  KHVCInfoPathItem.h
//  KHVCInfo
//
//  Created by Kent Humphries on 22/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHVCInfoPathItem : NSObject

/**
 *  @property Name of this pathItem
 */
@property (strong, nonatomic, readonly) NSString *name;

/**
 *  @property Describes the relationship to the item next in the path
 */
@property (strong, nonatomic, readonly) NSString *nextItemRelationship;

/**
 *  Initialise a new KHVCInfoPath object
 *
 *  @param name                 Name of this pathItem
 *  @param nextItemRelationship Describes the relationship to the item next in the path
 *
 *  @return A new KHVCInfoPath object
 */
- (instancetype)initWithName:(NSString*)name nextItemRelationship:(NSString*)nextItemRelationship;

@end
