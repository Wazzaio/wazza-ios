//
//  SDK.h
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchaseInfo.h"
#import "WazzaDelegate.h"

@interface WazzaAnalytics : NSObject

+(void)initWithCredentials:(NSString *)companyName
                        :(NSString *)applicationName
                        :(NSString *)secretKey;

#pragma Session functions

+(void)newSession;

+(void)resumeSession;

+(void)endSession;

#pragma Purchases functions

+(void)makePurchase:(NSString *)item;

#pragma Other stuff

+(void)allowGeoLocation;

+(void)setUserId:(NSString *)userId;

+(void)setDelegate:(id)delegate;

@end
