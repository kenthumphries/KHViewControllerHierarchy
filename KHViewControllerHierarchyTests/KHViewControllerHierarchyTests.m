//
//  KHViewControllerHierarchyTests.m
//  KHViewControllerHierarchyTests
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MySubViewController.h"
#import "MySubSubViewController.h"
#import "KHViewControllerHierarchyUtilities.h"

/**
 *  Currently tests positive cases only for object hierarchy & string creation
 */
@interface KHViewControllerHierarchyTests : XCTestCase

@end

@implementation KHViewControllerHierarchyTests

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
    UIViewController *topViewController = [KHViewControllerHierarchyUtilities ascendStackForViewController:[self navigationControllerHierarchyWithViewControllers:@[[MySubViewController new], [MySubSubViewController new]]]];
    
    NSString *hierarchy = [KHViewControllerHierarchyUtilities objectHierarchyForViewController:topViewController];
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
    
    UIViewController *topViewController = [KHViewControllerHierarchyUtilities ascendStackForViewController:tabBarController];
    
    NSString *hierarchy = [KHViewControllerHierarchyUtilities objectHierarchyForViewController:topViewController];
    NSString *expected  = @"MySubSubViewController-> MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
    
    
    tabBarController.selectedIndex = 0;
    
    topViewController = [KHViewControllerHierarchyUtilities ascendStackForViewController:tabBarController];
    
    hierarchy = [KHViewControllerHierarchyUtilities objectHierarchyForViewController:topViewController];
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
    UIViewController *topViewController = [KHViewControllerHierarchyUtilities ascendStackForViewController:[self modalViewControllerHierarchyOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                                                                                                                                                     withViewController:[MySubSubViewController new]]];
    
    NSString *hierarchy = [KHViewControllerHierarchyUtilities objectHierarchyForViewController:topViewController];
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
    UIViewController *topViewController = [KHViewControllerHierarchyUtilities ascendStackForViewController:parentViewController];
    
    NSString *hierarchy = [KHViewControllerHierarchyUtilities objectHierarchyForViewController:topViewController];
    NSString *expected  = @"MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
    
    
    // Remove the first childViewController view and add secondChildViewController view
    [[childViewControllers[0] view] removeFromSuperview];
    [parentViewController.view addSubview:[childViewControllers[1] view]];
    topViewController = [KHViewControllerHierarchyUtilities ascendStackForViewController:parentViewController];
    
    hierarchy = [KHViewControllerHierarchyUtilities objectHierarchyForViewController:topViewController];
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
    
    UIViewController *topViewController = [KHViewControllerHierarchyUtilities ascendStackForViewController:presentingViewController];
    
    NSString *hierarchy = [KHViewControllerHierarchyUtilities objectHierarchyForViewController:topViewController];
    NSString *expected  = @"MySubSubViewController-> MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
    
    // Ensure that navigationControllerWithNoChild is selected in tabBarController stack
    tabBarController.selectedIndex = 0;
    
    topViewController = [KHViewControllerHierarchyUtilities ascendStackForViewController:presentingViewController];
    
    hierarchy = [KHViewControllerHierarchyUtilities objectHierarchyForViewController:topViewController];
    expected  = @"MySubViewController-> UIViewController";
    XCTAssert([hierarchy isEqualToString:expected], @"\"%@\" != \"%@\"", hierarchy, expected);
}

@end
