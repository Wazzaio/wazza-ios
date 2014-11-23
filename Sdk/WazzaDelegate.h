//
//  WazzaSDKDelegate.h
//  Sdk
//
//  Created by Joao Vasques on 03/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchaseInfo.h"

/**
 *  Wazza delegate protocol
 */
@protocol WazzaDelegate <NSObject>

/**
 *  Protocol method that's called if a purchase request is successful
 */
@required
-(void)purchaseSuccess:(PurchaseInfo *)info;

/**
 *  Protocol method that's called if there was a problem with a purchase request
 */
@required
-(void)PurchaseFailure:(NSError *)error;

@end
