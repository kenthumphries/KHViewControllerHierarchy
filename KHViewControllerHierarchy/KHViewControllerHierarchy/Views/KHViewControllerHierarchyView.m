//
//  KHViewControllerHierarchyView.m
//  KHViewControllerHierarchy
//
//  Created by Kent Humphries on 21/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import "KHViewControllerHierarchyView.h"
#import "KHViewControllerHierarchyUtilities.h"

@interface KHViewControllerHierarchyView ()

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) NSMutableArray *myConstraints;

@end

@implementation KHViewControllerHierarchyView

+ (instancetype)hierarchyViewForViewController:(UIViewController*)viewController
{
    NSString *hierarchy = [KHViewControllerHierarchyUtilities objectHierarchyForViewController:viewController];
    
    return [[KHViewControllerHierarchyView alloc] initWithHierarchy:hierarchy];
}

- (instancetype)initWithHierarchy:(NSString *)hierarchy
{
    self = [super init];
    if (self)
    {
        self.label = [UILabel new];
        self.label.numberOfLines = 0;
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.label];
        
        self.label.text = hierarchy;
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.myConstraints)
    {
        self.myConstraints = [NSMutableArray new];
        
        // Ensure that label fills view
        NSDictionary *views = @{@"label" : self.label};
        [self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
        [self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
        [self addConstraints:self.myConstraints];
    }
    
    [super updateConstraints];
}

- (CGSize)intrinsicContentSize
{
    return self.label.intrinsicContentSize;
}

@end
