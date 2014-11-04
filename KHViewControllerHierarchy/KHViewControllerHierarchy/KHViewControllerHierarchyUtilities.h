//
//  KHViewControllerHierarchyUtilities.h
//  KHViewControllerHierarchyUtilities
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Utility object containing methods for determinining the current view hierarchy
 */
@interface KHViewControllerHierarchyUtilities : NSObject

/**
*  Show a view explaining the hiearchy of the current visible viewController
*
*  @param window UIWindow containing the current visible viewController
*/
+ (void)showAlertViewWithHierarchyForVisibleViewControllerOfWindow:(UIWindow*)window;

/**
 *  Return the object hierarchy of a given UIViewController up to (and including) UIViewController
 *  ie UINavigationController-> UIViewController
 *
 *  @param viewController UIViewController subclass to find object hierarchy for
 *
 *  @return NSString containing the object hierarchy of viewcontroller
 */
+ (NSString *)objectHierarchyForViewController:(UIViewController*)viewController;

/**
 *  Find the 'top' of the stack on top of the viewController
 *  Works for UINavigationController, UITabBarController, modally presented UIViewController, childViewController
 *
 *  @param viewController UIViewController subclass to find the top-most view on top of its
 *
 *  @return UIViewController that is at the top of the current UIViewController 'stack'
 */
+ (UIViewController *)ascendStackForViewController:(UIViewController *)viewController;

@end
