//
//  SDKCoreDelegate.h
//  WazzaSDK
//
//  Created by Joao Luis Vazao Vasques on 16/10/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchaseInfo.h"

@protocol SDKCoreDelegate <NSObject>

@required
+(void)corePurchaseSuccess:(PurchaseInfo *)info;

@required
+(void)corePurchaseFailure:(NSError *)error;

@end
