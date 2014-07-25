//
//  SdkTests.m
//  SdkTests
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Sdk.h"
#import <CoreData/CoreData.h>
#import "WazzaSDKDelegate.h"

@interface SdkTests : XCTestCase <WazzaSDKDelegate>

@property(nonatomic, strong) SDK *sdk;
@property(nonatomic, strong) dispatch_semaphore_t sem;
@property(nonatomic) BOOL purchaseTestResult;

@end

@implementation SdkTests

-(void)purchaseSuccess:(PurchaseInfo *)info {
    self.purchaseTestResult = true;
    dispatch_semaphore_signal(self.sem);
    NSLog(@"SUCCESS!!!! %@", info);
}

-(void)PurchaseFailure:(NSError *)error {
    self.purchaseTestResult = false;
    dispatch_semaphore_signal(self.sem);
    NSLog(@"FAIL!!!! %@", error);
}

- (void)setUp
{
    [super setUp];
    self.sdk = [[SDK alloc] initWithCredentials:@"App" :@"companyName" :@"d7b7e2f5280e89236ed45474"];
    self.sdk.delegate = self;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSDKBootstrap
{
    [self.sdk endSession];
//    dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
    XCTAssertTrue(self.sdk != nil);
}

//-(void)testMakePurchase {
//    NSArray *items = [self.sdk getItems:1];
//    if (items == nil) {
//        XCTFail("list of items is null");
//    }
//    
//    Item *item = items[0];
//    if (item == nil) {
//        XCTFail("Item is null");
//    }
//    
//    [self.sdk makePurchase:item];
//    dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
//    
//    XCTAssertTrue(self.purchaseTestResult);
//}

@end
