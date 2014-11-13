//
//  KHViewControllerHierarchyCustomiser.m
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "KHViewControllerHierarchyCustomiser.h"

@interface KHViewControllerHierarchyCustomiser ()

@property (nonatomic, strong) NSMutableDictionary *customBlocks;

@property (nonatomic, strong) NSMutableArray *registeredClasses;

@end

@implementation KHViewControllerHierarchyCustomiser

-(NSMutableDictionary*)customBlocks
{
    if (!_customBlocks)
    {
        _customBlocks = [NSMutableDictionary new];
    }
    return _customBlocks;
}

-(NSMutableArray*)registeredClasses
{
    if (!_registeredClasses)
    {
        _registeredClasses = [NSMutableArray new];
    }
    return _registeredClasses;}

-(void) registerClass:(Class)class withAscendStackBlock:(KHViewControllerHierarchyAscendStackBlock)ascendStack
{
    if (class && ascendStack)
    {
        // If class is already registered, shift it to the end of registeredClasses
        if ([self.registeredClasses containsObject:class])
        {
            [self.registeredClasses removeObject:class];
        }
        self.customBlocks[class.description] = ascendStack;
        [self.registeredClasses addObject:class];
    }
}

-(void) deregisterClass:(Class)class
{
    [self.customBlocks removeObjectForKey:class.description];
    [self.registeredClasses removeObject:class];
}

-(KHViewControllerHierarchyAscendStackBlock)ascendStackBlockForClass:(Class)viewControllerClass
{
    // Iterate through registeredClasses in order to ensure any subclasses are chosen first
    for (Class registeredClass in self.registeredClasses)
    {
        if ([viewControllerClass isSubclassOfClass:registeredClass])
        {
            return self.customBlocks[registeredClass.description];
        }
    }
    return nil;
}

@end
