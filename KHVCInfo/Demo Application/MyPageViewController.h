//
//  MyPageViewController.h
//  KHVCInfo
//
//  Created by Kent Humphries on 13/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageViewController : UIPageViewController

/**
 *  Convenience initialiser to initialise with an array of UIViewControllers
 *
 *  @param viewControllers Array of UIViewControllers to display in this UIPageViewController
 *
 *  @return Newly allocated instance
 */
- (instancetype)initWithViewControllers:(NSArray*)viewControllers;

@end
