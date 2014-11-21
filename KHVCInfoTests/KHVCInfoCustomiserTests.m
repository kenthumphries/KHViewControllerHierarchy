//
//  KHVCInfoCustomiserTests.m
//  KHVCInfo
//
//  Created by Kent Humphries on 12/11/2014.
//  Copyright (c) 2014 Kent Humphries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MySubViewController.h"
#import "MySubSubViewController.h"
#import "KHVCInfoPathCustomiser.h"

@interface KHVCInfoCustomiserTests : XCTestCase

@end

@implementation KHVCInfoCustomiserTests

- (void)testRegisterDeregisterClass {
    KHVCInfoPathCustomiser *customiser = [KHVCInfoPathCustomiser new];
    
    // Should get back a nil block - haven't yet registered a class
    XCTAssertNil([customiser ascendStackBlockForClass:MySubViewController.class]);
    
    [customiser registerClass:MySubViewController.class withAscendStackBlock:^UIViewController *(UIViewController *viewController, NSMutableString *pathString) {
        return [MySubViewController new];
    }];
    
    // Should get a non-nil block back now
    XCTAssertNotNil([customiser ascendStackBlockForClass:MySubViewController.class]);
    
    [customiser deregisterClass:MySubSubViewController.class];
    
    // Should still get a non-nil block back - deregistered nonexistent class
    XCTAssertNotNil([customiser ascendStackBlockForClass:MySubViewController.class]);
    
    [customiser deregisterClass:MySubViewController.class];
    
    // Should get back a nil block - deregistered correct class
    XCTAssertNil([customiser ascendStackBlockForClass:MySubViewController.class]);
}

- (void)testRegistrationOrder {
    
    // 1) Register superclass and ensure it's block is returned
    
    KHVCInfoPathCustomiser *customiser = [KHVCInfoPathCustomiser new];
    
    KHVCInfoAscendStackBlock mySubViewControllerBlock = ^UIViewController *(UIViewController *viewController, NSMutableString *pathString) {
        return [MySubViewController new];
    };
    KHVCInfoAscendStackBlock mySubSubViewControllerBlock = ^UIViewController *(UIViewController *viewController, NSMutableString *pathString) {
        return [MySubSubViewController new];
    };

    
    [customiser registerClass:MySubViewController.class
         withAscendStackBlock:mySubViewControllerBlock];
    
    // Should get back the mySubViewControllerBlock
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubViewController.class], mySubViewControllerBlock, @"Expect mySubViewControllerBlock back");
    
    // 2) Register subclass and ensure superclass block is returned for sub & superclass
    
    [customiser registerClass:MySubSubViewController.class
         withAscendStackBlock:mySubSubViewControllerBlock];

    // Should get back the mySubViewControllerBlock for MySubViewController
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubViewController.class], mySubViewControllerBlock, @"Expect mySubViewControllerBlock back");

    // Should get back the mySubViewControllerBlock for MySubSubViewController as it's a subclass
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubSubViewController.class], mySubViewControllerBlock, @"Expect mySubViewControllerBlock back as it's a subclass of MySubSubViewController which was registered first");
    
    // 3) Deregister superclass and ensure subclass block is returned for subclass
    
    [customiser deregisterClass:MySubViewController.class];
    
    // Should get back a nil block - deregistered super class
    XCTAssertNil([customiser ascendStackBlockForClass:MySubViewController.class]);

    // Should get back the mySubSubViewControllerBlock for MySubSubViewController as superclass no longer present
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubSubViewController.class], mySubSubViewControllerBlock, @"Expect mySubSubViewControllerBlock back");

    // 4) Reregister superclass (remember order is important) and ensure subclass block is returned for subclass
    
    [customiser registerClass:MySubViewController.class
         withAscendStackBlock:mySubViewControllerBlock];
    
    // Should get back the mySubSubViewControllerBlock for MySubSubViewController as superclass was registered AFTER MySubSubViewController
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubSubViewController.class], mySubSubViewControllerBlock, @"Expect mySubSubViewControllerBlock back");
    
    // Should get back the mySubViewControllerBlock for MySubViewController
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubViewController.class], mySubViewControllerBlock, @"Expect mySubViewControllerBlock back");
}

- (void)testRegistrationReorder
{
    // 1) Register superclass before subclass and ensure superclass block is returned for sub & superclass
    
    KHVCInfoPathCustomiser *customiser = [KHVCInfoPathCustomiser new];
    
    KHVCInfoAscendStackBlock mySubViewControllerBlock = ^UIViewController *(UIViewController *viewController, NSMutableString *pathString) {
        return [MySubViewController new];
    };
    KHVCInfoAscendStackBlock mySubSubViewControllerBlock = ^UIViewController *(UIViewController *viewController, NSMutableString *pathString) {
        return [MySubSubViewController new];
    };
    
    [customiser registerClass:MySubViewController.class
         withAscendStackBlock:mySubViewControllerBlock];
    [customiser registerClass:MySubSubViewController.class
         withAscendStackBlock:mySubSubViewControllerBlock];
    
    // Should get back the mySubViewControllerBlock for MySubViewController
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubViewController.class], mySubViewControllerBlock, @"Expect mySubViewControllerBlock back");
    
    // Should get back the mySubViewControllerBlock for MySubSubViewController as it's a subclass
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubSubViewController.class], mySubViewControllerBlock, @"Expect mySubViewControllerBlock back as it's a subclass of MySubSubViewController which was registered first");
    
    // 2) Re-register mySubViewController so it's moved to the end and MySubSubControllerBlock is returned for subclass
    [customiser registerClass:MySubViewController.class
         withAscendStackBlock:mySubViewControllerBlock];

    // Should get back the mySubViewControllerBlock for MySubViewController
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubViewController.class], mySubViewControllerBlock, @"Expect mySubViewControllerBlock back");
    
    // Should get back the mySubSubViewControllerBlock for MySubSubViewController as it's registered before MySubViewController
    XCTAssertEqual([customiser ascendStackBlockForClass:MySubSubViewController.class], mySubSubViewControllerBlock, @"Expect mySubSubViewControllerBlock back");
}

@end
