//
//  KHVCInfoUtilities.m
//  KHVCInfo
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "KHVCInfoUtilities.h"
#import "KHVCInfoPathItem.h"

@implementation KHVCInfoUtilities

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
                                          withPath:(NSMutableArray *)path
                                withPathCustomiser:(KHVCInfoPathCustomiser*)customiser
{
    if (!path.count)
    {
        KHVCInfoPathItem *item = [[KHVCInfoPathItem alloc] initWithName:@"UIWindow"
                                                   nextItemRelationship:@"has rootViewController"];
        [path addObject:item];
    }
    
    UIViewController *topOfStack = viewController;
    
    KHVCInfoAscendStackBlock customBlock = [customiser ascendStackBlockForClass:viewController.class];
    if (customBlock)
    {
        topOfStack = customBlock(viewController, path);
    }
    else if ([viewController isKindOfClass:UINavigationController.class])
    {
        topOfStack = [self ascendStackForNavigationController:(UINavigationController*)viewController withPath:path];
    }
    else if ([viewController isKindOfClass:UITabBarController.class])
    {
        topOfStack = [self ascendStackForTabBarController:(UITabBarController*)viewController withPath:path];
    }
    else if ([viewController isKindOfClass:UIPageViewController.class])
    {
        topOfStack = [self ascendStackForPageViewController:(UIPageViewController*)viewController withPath:path];
    }
    else if ([viewController presentedViewController])
    {
        topOfStack = [self ascendStackForPresentingViewController:viewController withPath:path];
    }
    else if (viewController.childViewControllers.count)
    {
        topOfStack = [self ascendStackForChildrenOfViewController:viewController withPath:path];
    }
    
    if (topOfStack == viewController)
    {
        KHVCInfoPathItem *item = [[KHVCInfoPathItem alloc] initWithName:viewController.class.description
                                                   nextItemRelationship:nil];
        [path addObject:item];

        return topOfStack;
    }
    
    return [self ascendStackForViewController:topOfStack withPath:path withPathCustomiser:customiser];
}

+ (UIViewController*)ascendStackForNavigationController:(UINavigationController*)navigationController withPath:(NSMutableArray *)path
{
    KHVCInfoPathItem *item = [[KHVCInfoPathItem alloc] initWithName:navigationController.class.description
                                               nextItemRelationship:@"has topViewController"];
    [path addObject:item];

    UIViewController *topViewController = [navigationController topViewController];
    return topViewController;
}

+ (UIViewController *)ascendStackForTabBarController:(UITabBarController*)tabBarController withPath:(NSMutableArray *)path
{
    KHVCInfoPathItem *item = [[KHVCInfoPathItem alloc] initWithName:tabBarController.class.description
                                               nextItemRelationship:@"has selectedViewController"];
    [path addObject:item];
    
    UIViewController *topViewController = [tabBarController selectedViewController];
    return topViewController;
}

+ (UIViewController *)ascendStackForChildrenOfViewController:(UIViewController *)viewController withPath:(NSMutableArray *)path
{
    for (UIViewController *childViewController in viewController.childViewControllers)
    {
        if ([viewController.view.subviews containsObject:childViewController.view])
        {
            KHVCInfoPathItem *item = [[KHVCInfoPathItem alloc] initWithName:viewController.class.description
                                                       nextItemRelationship:@"has visible childViewController"];
            [path addObject:item];
            return childViewController;
        }
        else if (childViewController.childViewControllers.count)
        {
            return [self ascendStackForChildrenOfViewController:childViewController withPath:path];
        }
    }
    return viewController;
}

+ (UIViewController *)ascendStackForPageViewController:(UIPageViewController *)pageViewController withPath:(NSMutableArray *)path
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
    
    KHVCInfoPathItem *item = [[KHVCInfoPathItem alloc] initWithName:pageViewController.class.description
                                               nextItemRelationship:@"showing"];
    [path addObject:item];
    return topViewController;
}

+ (UIViewController*)ascendStackForPresentingViewController:(UIViewController*)viewController
                                                   withPath:(NSMutableArray*)path
{
    KHVCInfoPathItem *item = [[KHVCInfoPathItem alloc] initWithName:viewController.class.description
                                               nextItemRelationship:@"presenting"];
    [path addObject:item];
    
    return [viewController presentedViewController];
}

@end
