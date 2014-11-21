//
//  KHViewControllerHierarchyUtilities.m
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "KHViewControllerHierarchyUtilities.h"

@implementation KHViewControllerHierarchyUtilities

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
                                    withPathString:(NSMutableString *)pathString
                             withCustomHierarchies:(KHViewControllerHierarchyCustomiser*)customiser
{
    if (!pathString.length)
    {
        [pathString appendFormat:@"UIWindow (has rootViewController) %@",viewController.class.description];
    }
    
    UIViewController *topOfStack = viewController;

    KHViewControllerHierarchyAscendStackBlock customBlock = [customiser ascendStackBlockForClass:viewController.class];
    if (customBlock)
    {
        topOfStack = customBlock(viewController, pathString);
    }
    else if ([viewController isKindOfClass:UINavigationController.class])
    {
        topOfStack = [self ascendStackForNavigationController:(UINavigationController*)viewController withPathString:pathString];
    }
    else if ([viewController isKindOfClass:UITabBarController.class])
    {
        topOfStack = [self ascendStackForTabBarController:(UITabBarController*)viewController withPathString:pathString];
    }
    else if ([viewController isKindOfClass:UIPageViewController.class])
    {
        topOfStack = [self ascendStackForPageViewController:(UIPageViewController*)viewController withPathString:pathString];
    }
    else if ([viewController presentedViewController])
    {
        UIViewController *topViewController = [viewController presentedViewController];
        [pathString appendFormat:@" (presenting) %@", topViewController.class.description];
        topOfStack = [self ascendStackForViewController:topViewController withPathString:pathString withCustomHierarchies:customiser];
    }
    else if (viewController.childViewControllers.count)
    {
        topOfStack = [self ascendStackForChildrenOfViewController:viewController withPathString:pathString];
    }
    
    if (topOfStack == viewController)
    {
        return topOfStack;
    }
    
    return [self ascendStackForViewController:topOfStack withPathString:pathString withCustomHierarchies:customiser];
}

+ (UIViewController*)ascendStackForNavigationController:(UINavigationController*)navigationController withPathString:(NSMutableString *)pathString
{
    UIViewController *topViewController = [navigationController topViewController];
    [pathString appendFormat:@" (has topViewController) %@", topViewController.class.description];
    return topViewController;
}

+ (UIViewController *)ascendStackForTabBarController:(UITabBarController*)tabBarController withPathString:(NSMutableString *)pathString
{
    UIViewController *topViewController = [tabBarController selectedViewController];
    [pathString appendFormat:@" (has selectedViewController) %@", topViewController.class.description];
    return topViewController;
}

+ (UIViewController *)ascendStackForChildrenOfViewController:(UIViewController *)viewController withPathString:(NSMutableString *)pathString
{
    for (UIViewController *childViewController in viewController.childViewControllers)
    {
        if ([viewController.view.subviews containsObject:childViewController.view])
        {
            [pathString appendFormat:@" (has visible childViewController) %@", childViewController.class.description];
            return childViewController;
        }
        else if (childViewController.childViewControllers.count)
        {
            return [self ascendStackForChildrenOfViewController:childViewController withPathString:pathString];
        }
    }
    return viewController;
}

+ (UIViewController *)ascendStackForPageViewController:(UIPageViewController *)pageViewController withPathString:(NSMutableString *)pathString
{
    UIViewController *topViewController = pageViewController.viewControllers[0]; // Default
    if ([pageViewController.dataSource respondsToSelector:@selector(presentationIndexForPageViewController:)])
    {
        NSInteger selectedIndex = [pageViewController.dataSource presentationIndexForPageViewController:pageViewController];
        if (selectedIndex < pageViewController.viewControllers.count)
        {
            topViewController = pageViewController.viewControllers[selectedIndex];
        }
    }
    
    [pathString appendFormat:@" (showing) %@", topViewController.class.description];
    return topViewController;
}

@end
