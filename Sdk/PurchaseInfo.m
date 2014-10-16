//
//  Purchase.m
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "PurchaseInfo.h"
#import "LocationInfo.h"
#import "SecurityService.h"

@implementation PurchaseInfo

-(id)initCommon {
    self = [super init];
    
    /**
     Purchase Id format: Hash(appName + itemID + time + device)
     **/
    NSString*(^generateID)(void) = ^NSString* {
        SecurityService *securityService = [[SecurityService alloc] init];
        NSString *idValue = [[NSString alloc] initWithFormat:@"%@-%@-%@-%@", self.applicationName, self.itemId, [self dateToString], @""];
        return [securityService hashContent:idValue];
    };
    
    if (self) {
        self.time = [NSDate date];
        self.location = Nil; //TODO
        self._id = generateID();
        self.deviceInfo = [[DeviceInfo alloc] initDeviceInfo];
    }
    return self;
}

-(id)initWithData:(NSString *)name
                 :(NSString *)itemId
                 :(double)price
                 :(NSString *)userId {
    self = [self initCommon];
    
    if (self) {
        self.applicationName = name;
        self.itemId = itemId;
        self.price = price;
        self.userId = userId;
    }
    
    return self;
}

-(id)initFromTransaction:(SKPaymentTransaction *)transaction
                        :(NSString *)name
                        : (double)price
                        :(NSString *)userId {
    self = [self initCommon];
    
    if (self) {
        self.applicationName = name;
        self.itemId = transaction.payment.productIdentifier;
        self.price = price;
        self.time = transaction.transactionDate;
        self.transactionId = transaction.transactionIdentifier;
        self.transactionReceipt = nil; //transaction.transactionReceipt;
        self.quantity = transaction.payment.quantity;
    }
    
    return self;
}

-(NSString *)dateToString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZZ";
    return[formatter stringFromDate:self.time];
}

-(NSDictionary *)toJson {
    
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    NSString *time = [self dateToString];
    
    [json setObject:self._id forKey:@"id"];
    [json setObject:self.userId forKey:@"userId"];
    [json setObject:self.applicationName forKey:@"name"];
    [json setObject:self.itemId forKey:@"itemId"];
    [json setObject:[[NSNumber alloc] initWithDouble:self.price] forKey:@"price"];
    [json setObject:time forKey:@"time"];
    [json setObject:[self.deviceInfo toJson] forKey:@"deviceInfo"];
    [json setObject:self.sessionHash forKey:@"sessionHash"];
    
    return json;
}

@end
