//
//  AppDelegate.m
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+KHViewControllerHierarchy.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self enableViewControllerHierarchyButton:YES forPrimaryWindow:self.window];
    
    return YES;
}

@end
