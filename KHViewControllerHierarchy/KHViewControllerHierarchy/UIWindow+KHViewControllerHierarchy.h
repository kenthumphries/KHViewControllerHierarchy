//
//  UIWindow+KHViewControllerHierarchy.h
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Category that exposes a 'button' (a UIWindow with gesture recognizers) for displaying current view controller hierarchy.
 *
 *   Uses set & getter so that viewControllerHierarchyButtonEnabled can be accessed like a property if desired.
 */
@interface UIWindow (KHViewControllerHierarchy)

/**
 *  Enable a 'button' that when touched will show hierarchy of the currently visible view controller.
 *
 *  @param buttonEnabled BOOL indicating whether 'button' should be enabled
 */
- (void)setViewControllerHierarchyButtonEnabled:(BOOL)buttonEnabled;

/**
 *  Getter to indicate whether the hierarchy 'button' is currently visible.
 */
- (BOOL)viewControllerHierarchyButtonEnabled;

@end
