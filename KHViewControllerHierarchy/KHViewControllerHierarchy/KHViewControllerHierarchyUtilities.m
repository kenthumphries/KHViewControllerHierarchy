//
//  KHViewControllerHierarchyUtilities.m
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "KHViewControllerHierarchyUtilities.h"

@implementation KHViewControllerHierarchyUtilities

+ (void)showAlertViewWithHierarchyForVisibleViewControllerOfWindow:(UIWindow*)window
{
    // Determine the top of the ViewController hierarchy
    UIViewController *visibleViewController = [self ascendStackForViewController:window.rootViewController];
    
    NSString *viewControllerHierarchy = [self objectHierarchyForViewController:visibleViewController];
    
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", object_getClassName(visibleViewController)]
                                message:viewControllerHierarchy
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

+ (NSString *)objectHierarchyForViewController:(UIViewController*)viewController
{
    NSString *classHierarchy = [viewController.class description];
    if (viewController.class != UIViewController.class)
    {
        Class currentClass = [viewController superclass];
        
        while (currentClass != UIViewController.class)
        {
            classHierarchy = [classHierarchy stringByAppendingFormat:@"-> %@", currentClass.description];
            
            currentClass = [currentClass superclass];
        }
        
        classHierarchy = [classHierarchy stringByAppendingFormat:@"-> %@", currentClass.description];
    }
    return classHierarchy;
}

+ (UIViewController *)ascendStackForViewController:(UIViewController *)viewController
{
    UIViewController *topOfStack = viewController;
    if ([viewController isKindOfClass:UINavigationController.class])
    {
        topOfStack = [self ascendStackForNavigationController:(UINavigationController*)viewController];
    }
    else if ([viewController isKindOfClass:UITabBarController.class])
    {
        topOfStack = [self ascendStackForTabBarController:(UITabBarController*)viewController];
    }
    else if ([viewController presentedViewController])
    {
        topOfStack = [self ascendStackForViewController:[viewController presentedViewController]];
    }
    else if (viewController.childViewControllers.count)
    {
        topOfStack = [self ascendStackForChildrenOfViewController:viewController];
    }
    
    if (topOfStack == viewController)
    {
        return topOfStack;
    }
    
    return [self ascendStackForViewController:topOfStack];
}

+ (UIViewController*)ascendStackForNavigationController:(UINavigationController*)navigationController
{
    return [navigationController topViewController];
}

+ (UIViewController *)ascendStackForTabBarController:(UITabBarController*)tabBarController
{
    return [tabBarController selectedViewController];
}

+ (UIViewController *)ascendStackForChildrenOfViewController:(UIViewController *)viewController
{
    for (UIViewController *childViewController in viewController.childViewControllers)
    {
        if ([viewController.view.subviews containsObject:childViewController.view])
        {
            return childViewController;
        }
    }
    return viewController;
}


@end
