//
//  KHViewControllerHierarchyCustomiser.h
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Block that is given a UIViewController and returns it's 'top' UIViewController
 *
 *  @param viewController viewController to ascend to 'top'
 *  @param pathString NSMutableString which shows relation from viewController to 'top' UIViewController
 *
 *  @return UIViewController at 'top' of viewController's direct hierarchy
 */
typedef UIViewController *(^KHViewControllerHierarchyAscendStackBlock)(UIViewController *viewController, NSMutableString *pathString);

/**
 *  Configuration class used to customise actions in KHViewControllerHierarchyUtilities
 */
@interface KHViewControllerHierarchyCustomiser : NSObject

/**
 *  Register a Class such that any instance of this class (or it's subclasses) will use the associated block to find it's 'top' UIViewController.
 *  Note that a classes will be queried in order of registration. To handle a special subclass, register it first
 *
 *  @param class       Class to find 'top' UIViewController for
 *  @param ascendStack Block that finds 'top' UIViewController for a given class
 */
-(void) registerClass:(Class)class withAscendStackBlock:(KHViewControllerHierarchyAscendStackBlock)ascendStack;

/**
 *  Deregister a Class so that default method is used to find 'top' UIViewController for this class (and it's subclasses)
 *
 *  @param class Class to deregister
 */
-(void) deregisterClass:(Class)class;

/**
 *  Return the KHViewControllerHierarchyAscendStackBlock registered for a given class
 *
 *  @param class Class to find the ascendStackBlock for
 *
 *  @return KHViewControllerHierarchyAscendStackBlock that returns the 'top' UIViewController for a given viewController
 */
-(KHViewControllerHierarchyAscendStackBlock)ascendStackBlockForClass:(Class)class;

@end
