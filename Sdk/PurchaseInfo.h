//
//  Purchase.h
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationInfo.h"
#import "DeviceInfo.h"
#import <StoreKit/StoreKit.h>

@interface PurchaseInfo : NSObject

@property(nonatomic) NSString *_id;
@property(nonatomic) NSString *userId;
@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *itemId;
@property(nonatomic) double price;
@property(nonatomic) NSDate *time;
@property(nonatomic, strong) LocationInfo *location;
@property(nonatomic, strong) DeviceInfo *deviceInfo;
@property(nonatomic) NSString *transactionId;
@property(nonatomic) NSData *transactionReceipt;
@property(nonatomic) NSInteger quantity;

-(id)initWithData:(NSString *)name :(NSString *)itemId : (double)price;

-(id)initFromTransaction:(SKPaymentTransaction *)transaction
                 appName:(NSString *)name
               itemPrice: (double)price;

-(NSDictionary *)toJson;

@end
