//
//  UIWindow+KHViewControllerHierarchy.h
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KHViewControllerHierarchyCustomiser;

/**
 *  Category that exposes a 'button' (a UIWindow with gesture recognizers) for displaying current view controller hierarchy.
 *
 *   Uses set & getter so that viewControllerHierarchyButtonEnabled can be accessed like a property if desired.
 */
@interface UIWindow (KHViewControllerHierarchy)

/**
 *  @property Customiser applied when calling KHViewControllerHierarchyUtilities methods
 */
@property (nonatomic, readonly) KHViewControllerHierarchyCustomiser *viewControllerHierarchyCustomiser;

/*
 * @property Enable a 'button' that when touched will show hierarchy of the currently visible view controller.
 */
@property (nonatomic, assign) BOOL viewControllerHierarchyButtonEnabled;

@end

