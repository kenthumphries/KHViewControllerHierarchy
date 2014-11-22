//
//  KHVCInfoTests.m
//  KHVCInfoTests
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MySubViewController.h"
#import "MySubSubViewController.h"
#import "MyPageViewController.h"
#import "KHVCInfoUtilities.h"

/**
 *  Currently tests positive cases only for object hierarchy & string creation
 */
@interface KHVCInfoUtilitiesTests : XCTestCase

@end

@implementation KHVCInfoUtilitiesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNavigationControllerHierarchy {
    
    // Create a UINavigationController hierarchy and test objectHierarchy
    UIViewController *topViewController = [KHVCInfoUtilities ascendStackForViewController:[self navigationControllerHierarchyWithViewControllers:@[[MySubViewController new], [MySubSubViewController new]]] withPath:nil withPathCustomiser:nil];
    
    NSString *hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    NSString *expected  = @"MySubSubViewController-> MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
}

- (UINavigationController*)navigationControllerHierarchyWithViewControllers:(NSArray*)viewControllers
{
    UINavigationController *navigationController = [UINavigationController new];
    for (UIViewController *viewController in viewControllers)
    {
        [navigationController pushViewController:viewController animated:NO];
    }
    return navigationController;
}

- (void)testTabBarControllerHierarchy {
    
    // Create a UITabBarController hierarchy and test objectHierarchy
    UITabBarController *tabBarController = [self tabBarControllerHierarchyWithViewController:@[[MySubViewController new], [MySubSubViewController new]]];
    
    tabBarController.selectedIndex = 1;
    
    UIViewController *topViewController = [KHVCInfoUtilities ascendStackForViewController:tabBarController withPath:nil withPathCustomiser:nil];
    
    NSString *hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    NSString *expected  = @"MySubSubViewController-> MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
    
    
    tabBarController.selectedIndex = 0;
    
    topViewController = [KHVCInfoUtilities ascendStackForViewController:tabBarController withPath:nil withPathCustomiser:nil];
    
    hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    expected  = @"MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
}

- (UITabBarController*)tabBarControllerHierarchyWithViewController:(NSArray*)viewControllers
{
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = viewControllers;
    return tabBarController;
}

- (void)testModalViewControllerHierarchy {
    
    // Create a ModalViewController hierarchy and test objectHierarchy
    UIViewController *topViewController = [KHVCInfoUtilities ascendStackForViewController:[self modalViewControllerHierarchyOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                                                                                                          withViewController:[MySubSubViewController new]] withPath:nil withPathCustomiser:nil];
    
    NSString *hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    NSString *expected  = @"MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
}

- (UIViewController*)modalViewControllerHierarchyOnViewController:(UIViewController*)presentingViewController
                                               withViewController:(UIViewController*)viewController
{
    [presentingViewController presentViewController:viewController animated:NO completion:nil];
    return presentingViewController;
}

- (void)testChildViewControllerHierarchy {
    
    // Create a ModalViewController hierarchy and test objectHierarchy
    NSArray *childViewControllers = @[[MySubViewController new], [MySubSubViewController new]];
    UIViewController *parentViewController = [self parentViewControllerHierarchyWithViewControllers:childViewControllers];
    
    // Add the first childViewController view
    [parentViewController.view addSubview:[childViewControllers[0] view]];
    UIViewController *topViewController = [KHVCInfoUtilities ascendStackForViewController:parentViewController withPath:nil withPathCustomiser:nil];
    
    NSString *hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    NSString *expected  = @"MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
    
    
    // Remove the first childViewController view and add secondChildViewController view
    [[childViewControllers[0] view] removeFromSuperview];
    [parentViewController.view addSubview:[childViewControllers[1] view]];
    topViewController = [KHVCInfoUtilities ascendStackForViewController:parentViewController withPath:nil withPathCustomiser:nil];
    
    hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    expected  = @"MySubSubViewController-> MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
}

- (UIViewController*)parentViewControllerHierarchyWithViewControllers:(NSArray*)viewControllers
{
    UIViewController *parentViewController = [UIViewController new];
    
    for (UIViewController *viewController in viewControllers)
    {
        [parentViewController addChildViewController:viewController];
    }
    return parentViewController;
}


- (void)testMixedViewControllerHierarchy {
    // ModalViewController containing a navigation controller containing a tab bar controller containing two navigation controllers, one with child container views, one without
    
    NSArray *childViewControllers = @[[MySubViewController new], [MySubSubViewController new]];
    UIViewController *parentViewController = [self parentViewControllerHierarchyWithViewControllers:childViewControllers];
    // Ensure that childViewControllers[1] (MySubSubViewController) is 'top' of parentViewController stack
    [parentViewController.view addSubview:[childViewControllers[1] view]];
    
    // Ensure that parentViewcontroller is in navigationControllerWithChild stack
    UIViewController *navigationControllerWithChild = [self navigationControllerHierarchyWithViewControllers:@[parentViewController]];
    
    // Ensure that 'MySubViewController' is 'top' of navigationControllerWithNoChild stack
    UIViewController *navigationControllerWithNoChild = [self navigationControllerHierarchyWithViewControllers:@[[MySubViewController new]]];
    
    UITabBarController *tabBarController = [self tabBarControllerHierarchyWithViewController:@[navigationControllerWithNoChild, navigationControllerWithChild]];
    
    // Ensure that tabBarController is in navigationControllerWithTabBar stack
    UINavigationController *navigationControllerWithTabBar = [self navigationControllerHierarchyWithViewControllers:@[tabBarController]];
    
    // Ensure that navigationControllerWithTabBar is in presentingViewController stack
    UIViewController *presentingViewController = [self modalViewControllerHierarchyOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController withViewController:navigationControllerWithTabBar];
    
    
    // Ensure that navigationControllerWithChild is selected in tabBarController stack
    tabBarController.selectedIndex = 1;
    
    UIViewController *topViewController = [KHVCInfoUtilities ascendStackForViewController:presentingViewController withPath:nil withPathCustomiser:nil];
    
    NSString *hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    NSString *expected  = @"MySubSubViewController-> MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
    
    // Ensure that navigationControllerWithNoChild is selected in tabBarController stack
    tabBarController.selectedIndex = 0;
    
    topViewController = [KHVCInfoUtilities ascendStackForViewController:presentingViewController withPath:nil withPathCustomiser:nil];
    
    hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    expected  = @"MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
}

- (void)testPageViewControllerHierarchy
{
    // Create a MyPageViewController and test objectHierarchy
    NSArray *viewControllers = @[[MySubViewController new], [MySubSubViewController new], [MySubViewController new]];
    MyPageViewController *pageViewController = [self pageViewControllerHierarchyWithViewControllers:viewControllers];
    
    // Force the pageViewController to load it's view
    [pageViewController.view setNeedsDisplay];
    
    UIViewController *topViewController = [KHVCInfoUtilities ascendStackForViewController:pageViewController
                                                                           withPath:nil withPathCustomiser:nil];
    
    NSString *hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    NSString *expected  = @"MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
    
    // Select the next page
    [pageViewController setViewControllers:@[viewControllers[1]]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:NO
                                completion:nil];
    
    topViewController = [KHVCInfoUtilities ascendStackForViewController:pageViewController
                                                         withPath:nil withPathCustomiser:nil];
    
    hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    expected  = @"MySubSubViewController-> MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
    
    // Select the last page
    [pageViewController setViewControllers:@[viewControllers.lastObject]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:NO
                                completion:nil];
    
    topViewController = [KHVCInfoUtilities ascendStackForViewController:pageViewController
                                                         withPath:nil withPathCustomiser:nil];
    
    hierarchy = [KHVCInfoUtilities objectHierarchyForViewController:topViewController];
    expected  = @"MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
}

- (MyPageViewController*)pageViewControllerHierarchyWithViewControllers:(NSArray*)viewControllers
{
    MyPageViewController *pageViewController = [[MyPageViewController alloc] initWithViewControllers:viewControllers];
    return pageViewController;
}

@end
