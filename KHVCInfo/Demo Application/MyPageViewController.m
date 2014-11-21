//
//  MyPageViewController.m
//  KHVCInfo
//
//  Created by Kent Humphries on 13/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "MyPageViewController.h"
#import "MySubViewController.h"
#import "MySubSubViewController.h"

@interface MyPageViewController ()  <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray *dataSourceViewControllers;
@end

@implementation MyPageViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.dataSourceViewControllers = @[[MySubViewController new], [MySubSubViewController new]];
    }
    return self;
}

- (instancetype)initWithViewControllers:(NSArray*)viewControllers
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:nil];
    if (self)
    {
        self.dataSourceViewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate   = self;

    [self setViewControllers:@[self.dataSourceViewControllers[0]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
    self.view.backgroundColor = [UIColor purpleColor];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentPage > 0)
    {
        self.currentPage--;
    }
    else
    {
        return nil; // Is no previous page
    }
    return self.dataSourceViewControllers[self.currentPage];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.currentPage < self.viewControllers.count)
    {
        self.currentPage++;
    }
    else
    {
        return nil;
    }
    return self.dataSourceViewControllers[self.currentPage];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.viewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.currentPage;
}


#pragma mark - UIPageViewControllerDelegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController*)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return UIPageViewControllerSpineLocationMin;
}

@end
