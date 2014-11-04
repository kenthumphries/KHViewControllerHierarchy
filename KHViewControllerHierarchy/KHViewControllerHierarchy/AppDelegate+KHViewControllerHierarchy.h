//
//  AppDelegate+KHViewControllerHierarchy.h
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "AppDelegate.h"

/**
 *  Category that exposes a 'button' (a UIWindow with gesture recognizers) for displaying current view controller hierarchy.
 */
@interface AppDelegate (KHViewControllerHierarchy)

/**
 *  Enable a 'button' that when touched will show hierarchy of the currently visible view controller.
 *
 *  @param showHierarchy BOOL indicating whether 'button' should be enabled
 *  @param window        UIWindow that will be queried for visible view controller to display hierarchy for
 */
- (void)enableViewControllerHierarchyButton:(BOOL)enableButton forPrimaryWindow:(UIWindow*)window;

@end
