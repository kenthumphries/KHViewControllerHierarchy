//
//  UIWindow+KHViewControllerHierarchy.m
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "UIWindow+KHViewControllerHierarchy.h"
#import "KHViewControllerHierarchyCustomiser.h"
#import "KHViewControllerHierarchyUtilities.h"
#import <objc/runtime.h>

static int const kHierarchyWindowDiameter = 100;

static NSString *const kCustomiserKey               = @"customiser";
static NSString *const kHierarchyWindowKey        = @"hierarchyWindow";
static NSString *const kHierarchyWindowOriginXKey = @"hierarchyWindowOriginX";
static NSString *const kHierarchyWindowOriginYKey = @"hierarchyWindowOriginY";

@implementation UIWindow (KHViewControllerHierarchy)

- (KHViewControllerHierarchyCustomiser*)viewControllerHierarchyCustomiser
{
    KHViewControllerHierarchyCustomiser *customiser = objc_getAssociatedObject(self, (__bridge const void *)(kCustomiserKey));
    if (!customiser)
    {
        customiser = [KHViewControllerHierarchyCustomiser new];
        objc_setAssociatedObject(self, (__bridge const void *)(kCustomiserKey), customiser, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return customiser;
}

- (UIWindow*)hierarchyWindow
{
    UIWindow *hierarchyWindow = objc_getAssociatedObject(self, (__bridge const void *)(kHierarchyWindowKey));
    if (!hierarchyWindow)
    {
        hierarchyWindow = [[UIWindow alloc] initWithFrame:CGRectMake(kHierarchyWindowDiameter,
                                                                     kHierarchyWindowDiameter,
                                                                     kHierarchyWindowDiameter,
                                                                     kHierarchyWindowDiameter)];
        hierarchyWindow.layer.cornerRadius = kHierarchyWindowDiameter * 0.5;
        hierarchyWindow.windowLevel = self.windowLevel + 1;
        hierarchyWindow.backgroundColor = [UIColor grayColor];
        hierarchyWindow.alpha = 0.2;
        hierarchyWindow.rootViewController = [UIViewController new]; // Avoid compiler warning - a window _should_ have a rootViewController
        
        UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHierarchyView)];
        [hierarchyWindow addGestureRecognizer:tapRecognizer];

        UIGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [hierarchyWindow addGestureRecognizer:panRecognizer];
        
        objc_setAssociatedObject(self, (__bridge const void *)(kHierarchyWindowKey), hierarchyWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return hierarchyWindow;
}

- (void)setHierarchyWindowOrigin:(CGPoint)origin
{
    objc_setAssociatedObject(self, (__bridge const void *)(kHierarchyWindowOriginXKey), @(origin.x), OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, (__bridge const void *)(kHierarchyWindowOriginYKey), @(origin.y), OBJC_ASSOCIATION_COPY);
}

- (CGPoint)hierarchyWindowOrigin
{
    NSNumber *originX = objc_getAssociatedObject(self,  (__bridge const void *)(kHierarchyWindowOriginXKey));
    NSNumber *originY = objc_getAssociatedObject(self,  (__bridge const void *)(kHierarchyWindowOriginYKey));
    return CGPointMake(originX.intValue, originY.intValue);
}

- (void)setViewControllerHierarchyButtonEnabled:(BOOL)buttonEnabled
{
    // Simply show or hide the hierarchyWindow. It's lazily loaded, so will be added if not already.
    self.hierarchyWindow.hidden = !buttonEnabled;
}

- (BOOL)viewControllerHierarchyButtonEnabled
{
    return !self.hierarchyWindow.hidden;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        // Do nothing
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        // Store the current location of the hierarchyWindow so it can be moved relatively
        [self setHierarchyWindowOrigin:self.hierarchyWindow.frame.origin];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        // Update the frame of the window given origin + offset
        CGPoint touch = [panGestureRecognizer translationInView:self];
        
        self.hierarchyWindow.frame = CGRectMake(self.hierarchyWindowOrigin.x + touch.x,
                                                self.hierarchyWindowOrigin.y + touch.y,
                                                self.hierarchyWindow.frame.size.width,
                                                self.hierarchyWindow.frame.size.height);
    }
}

- (void)showHierarchyView
{
    [KHViewControllerHierarchyUtilities showAlertViewWithHierarchyForVisibleViewControllerOfWindow:self withCustomHierarchies:self.viewControllerHierarchyCustomiser];
}

@end
