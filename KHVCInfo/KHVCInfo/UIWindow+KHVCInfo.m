//
//  UIWindow+KHVCInfo.m
//  KHVCInfo
//
//  Created by Kent Humphries on 4/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "UIWindow+KHVCInfo.h"
#import "KHVCInfoCustomiser.h"
#import "KHVCInfoUtilities.h"
#import <objc/runtime.h>
#import "KHVCInfoHierarchyView.h"

static int const kHierarchyWindowDiameter = 100;

static NSString *const kExpandedKey               = @"expanded";
static NSString *const kCustomiserKey             = @"customiser";
static NSString *const kHierarchyWindowKey        = @"hierarchyWindow";
static NSString *const kHierarchyWindowOriginXKey = @"hierarchyWindowOriginX";
static NSString *const kHierarchyWindowOriginYKey = @"hierarchyWindowOriginY";

@implementation UIWindow (KHVCInfo)

- (BOOL)expanded
{
    return [objc_getAssociatedObject(self, (__bridge const void *)(kExpandedKey)) boolValue];
}

- (void)setExpanded:(BOOL)expanded
{
    objc_setAssociatedObject(self, (__bridge const void *)(kExpandedKey), @(expanded), OBJC_ASSOCIATION_ASSIGN);
}

- (KHVCInfoCustomiser*)viewControllerHierarchyCustomiser
{
    KHVCInfoCustomiser *customiser = objc_getAssociatedObject(self, (__bridge const void *)(kCustomiserKey));
    if (!customiser)
    {
        customiser = [KHVCInfoCustomiser new];
        objc_setAssociatedObject(self, (__bridge const void *)(kCustomiserKey), customiser, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return customiser;
}

- (UIWindow*)hierarchyWindow
{
    UIWindow *hierarchyWindow = objc_getAssociatedObject(self, (__bridge const void *)(kHierarchyWindowKey));
    if (!hierarchyWindow)
    {
        [self setHierarchyWindowOrigin:CGPointMake(kHierarchyWindowDiameter, kHierarchyWindowDiameter)];

        hierarchyWindow = [[UIWindow alloc] initWithFrame:CGRectMake(self.hierarchyWindowOrigin.x,
                                                                     self.hierarchyWindowOrigin.y,
                                                                     kHierarchyWindowDiameter,
                                                                     kHierarchyWindowDiameter)];
        hierarchyWindow.layer.cornerRadius = kHierarchyWindowDiameter * 0.5;
        hierarchyWindow.windowLevel = self.windowLevel + 1;
        hierarchyWindow.backgroundColor = [UIColor lightGrayColor];
        hierarchyWindow.alpha = 0.2;
        hierarchyWindow.rootViewController = nil; // Avoid compiler warning - a window _should_ have a rootViewController
        
        UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHierarchyView:)];
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
    if (buttonEnabled)
    {
        [self.hierarchyWindow makeKeyAndVisible];
    }
    else
    {
        self.hierarchyWindow.hidden = YES;
        [self makeKeyWindow];
    }
//    self.hierarchyWindow.hidden = !buttonEnabled;
}

- (BOOL)viewControllerHierarchyButtonEnabled
{
    return !self.hierarchyWindow.hidden;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)panGestureRecognizer
{
    if (!self.expanded) // panning is disabled when expanded
    {
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            // Store the updated origin
            [self setHierarchyWindowOrigin:self.hierarchyWindow.frame.origin];
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
}

- (void)showHierarchyView:(UITapGestureRecognizer*)tapGestureRecognizer
{
    // Expand the hierarchyView to fill the entire window
    UIWindow *hierarchyWindow = self.hierarchyWindow;

    if (!self.expanded)
    {
        // Determine the top of the ViewController hierarchy & it's path
        NSMutableString *pathString = [NSMutableString new];
        UIViewController *visibleViewController = [KHVCInfoUtilities ascendStackForViewController:self.rootViewController withPathString:pathString withCustomHierarchies:self.viewControllerHierarchyCustomiser];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            hierarchyWindow.frame  = CGRectMake(20,
                                                20,
                                                self.frame.size.width - 40,
                                                self.frame.size.height - 40);
            
            hierarchyWindow.alpha = 0.9;

        } completion:^(BOOL finished) {
            
            UIScrollView *scrollView = [UIScrollView new];
            scrollView.alpha = 0.0;

            [hierarchyWindow addSubview:scrollView];
            scrollView.frame = CGRectMake(28,
                                          28,
                                          hierarchyWindow.frame.size.width - 40,
                                          hierarchyWindow.frame.size.height - 40);

            // View containing hierarchy info
            KHVCInfoHierarchyView *hierarchyView = [KHVCInfoHierarchyView hierarchyViewForViewController:visibleViewController];
            hierarchyView.translatesAutoresizingMaskIntoConstraints = NO;
            
            // Label containing path info
            UILabel *pathLabel = [UILabel new];
            
            NSString *title = [NSString stringWithFormat:@"Path to %@\n", visibleViewController.class.description];
            UIFont *font = [UIFont boldSystemFontOfSize:pathLabel.font.pointSize];
            NSDictionary *attrsDictionary = @{NSFontAttributeName : font};
            
            NSMutableAttributedString *pathText = [[NSMutableAttributedString alloc] initWithString:title
                                                                                              attributes:attrsDictionary];
            
            font = [UIFont systemFontOfSize:pathLabel.font.pointSize];
            attrsDictionary = @{NSFontAttributeName : font};
            [pathText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:pathString
                                                                                    attributes:attrsDictionary]];

            pathLabel.numberOfLines  = 0;
            pathLabel.attributedText = pathText;
            pathLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            [scrollView addSubview:hierarchyView];
            [scrollView addSubview:pathLabel];
            
            NSDictionary *views   = NSDictionaryOfVariableBindings(hierarchyView, pathLabel);
            NSDictionary *metrics = @{@"maxWidth" : @(scrollView.frame.size.width)};

            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[hierarchyView(<=maxWidth)]|"
                                                                                    options:0
                                                                                    metrics:metrics
                                                                                      views:views]];
            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[hierarchyView]-40-[pathLabel]|"
                                                                                    options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                                    metrics:nil
                                                                                      views:views]];
            
            [UIView animateWithDuration:0.05 animations:^{
                scrollView.alpha = 1.0;
            }];
        }];
        
        [self setExpanded:YES];
    }
    else
    {
        // Fade away UILabels
        [UIView animateWithDuration:0.05 animations:^{
            // Fade out any subviews of hierarchyWindow
            for (UIView *subview in hierarchyWindow.subviews)
            {
                subview.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            // Remove any subviews of hierarchy Window
            for (UIView *subview in hierarchyWindow.subviews)
            {
                [subview removeFromSuperview];
            }
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                hierarchyWindow.alpha = 0.2;
                
                hierarchyWindow.frame  = CGRectMake(self.hierarchyWindowOrigin.x,
                                                    self.hierarchyWindowOrigin.y,
                                                    kHierarchyWindowDiameter,
                                                    kHierarchyWindowDiameter);
            } completion:^(BOOL finished) {
                //Do nothing
            }];
        }];
        
        self.expanded = NO;
    }    
}

@end
