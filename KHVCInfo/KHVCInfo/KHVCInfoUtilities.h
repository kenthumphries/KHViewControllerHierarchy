//
//  KHVCInfoUtilities.h
//  KHVCInfoUtilities
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHVCInfoPathCustomiser.h"

/**
 *  Utility object containing methods for determinining the current view hierarchy
 */
@interface KHVCInfoUtilities : NSObject

/**
 *  Return the object hierarchy of a given UIViewController up to (and including) UIViewController
 *  ie UINavigationController-> UIViewController
 *
 *  @param viewController UIViewController subclass to find object hierarchy for
 *
 *  @return NSString containing the object hierarchy of viewcontroller
 *  @param customiser Customisation object used to extend functionality
 */
+ (NSString *)objectHierarchyForViewController:(UIViewController*)viewController;

/**
 *  Find the 'top' of the stack on top of the viewController
 *  Works for UINavigationController, UITabBarController, modally presented UIViewController, childViewController
 *
 *  @param viewController UIViewController subclass to find the top-most view on top of its
 *
 *  @param pathString NSMutableString that must be pre-initialised and will be filled with the path stack
 *  @param customiser Customisation object used to extend functionality
 *  @return UIViewController that is at the top of the current UIViewController 'stack'
 */
+ (UIViewController *)ascendStackForViewController:(UIViewController *)viewController
                                    withPathString:(NSMutableString *)pathString
                                withPathCustomiser:(KHVCInfoPathCustomiser*)customiser;

@end
