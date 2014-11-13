//
//  MyPageViewController.m
//  KHViewControllerHierarchy
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate   = self;

    self.dataSourceViewControllers = @[[MySubViewController new], [MySubSubViewController new]];

    // Only set the viewControllers here where they will correspond to correct spine location returned (Mid for 2 VCs)
    [self setViewControllers:@[self.dataSourceViewControllers[0]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
    
    self.view.backgroundColor = [UIColor purpleColor];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.currentPage = [self.dataSourceViewControllers indexOfObject:viewController] == 0 ? 1 : 0;
    return self.dataSourceViewControllers[self.currentPage];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.currentPage = [self.dataSourceViewControllers indexOfObject:viewController] == 0 ? 1 : 0;
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
