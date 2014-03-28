//
//  SdkTests.m
//  SdkTests
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SdkTests : XCTestCase

@end

@implementation SdkTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssertTrue(self.sdk != nil);
}

-(void)testPurchase {
    NSArray *items = [self.sdk getItems:2];
    if (items == nil) {
        XCTFail("list of items is null");
    }

    if ([items count] > 0) {
        Item *item = items[0];
        if (item == nil) {
            XCTFail("Item is null");
        }
        XCTAssertTrue([self.sdk makePurchase:item] == YES);
    }

    XCTAssertTrue(1 == 1);
}

@end
