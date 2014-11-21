//
//  KHVCInfoHierarchyView.h
//  KHVCInfo
//
//  Created by Kent Humphries on 21/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  View designed to display the hierarchy for a given class
 */
@interface KHVCInfoHierarchyView : UIView

/**
 *  Return a view for displaying the object hierarchy of a given UIViewController up to (and including) UIViewController
 *  ie UINavigationController-> UIViewController
 *
 *  @param viewController UIViewController subclass to find object hierarchy for
 *
 *  @return instanceType containing the object hierarchy of viewcontroller
 */
+ (instancetype)hierarchyViewForViewController:(UIViewController*)viewController;

@end