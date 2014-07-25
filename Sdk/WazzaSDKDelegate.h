//
//  WazzaSDKDelegate.h
//  Sdk
//
//  Created by Joao Vasques on 03/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchaseInfo.h"

@protocol WazzaSDKDelegate <NSObject>

@required
-(void)purchaseSuccess:(PurchaseInfo *)info;

@required
-(void)PurchaseFailure:(NSError *)error;

@end
