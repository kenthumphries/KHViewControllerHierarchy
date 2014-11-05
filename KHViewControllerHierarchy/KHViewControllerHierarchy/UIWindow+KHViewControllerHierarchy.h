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
 */
@interface UIWindow (KHViewControllerHierarchy)

/**
 *  Enable a 'button' that when touched will show hierarchy of the currently visible view controller.
 *
 *  @param showHierarchy BOOL indicating whether 'button' should be enabled
 */
- (void)enableViewControllerHierarchyButton:(BOOL)enableButton;

@end
