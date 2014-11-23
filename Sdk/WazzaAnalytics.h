//
//  WazzaAnalytics.h
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchaseInfo.h"
#import "WazzaDelegate.h"

@interface WazzaAnalytics : NSObject

/**
 *  Inits Wazza using a secret token
 *
 *  @param secretToken
 */
+(void)initWithSecret:(NSString *)secretToken;

#pragma Session functions

/**
 *  Creates a new session and stores it locally
 */
+(void)newSession;

/**
 *  TODO
 */
+(void)resumeSession;

/**
 *  Sends the current session to the server
 *  TODO: write when to call this
 */
+(void)endSession;

#pragma Purchases functions

/**
 *  Makes an in-app purchase request
 *
 *  @param item in-app purchase product ID
 */
+(void)makePurchase:(NSString *)item;

#pragma Other stuff

/**
 *  Activates geolocation. Used on session and purchases
 */
+(void)allowGeoLocation;

/**
 *  <#Description#>
 *
 *  @param delegate <#delegate description#>
 */
+(void)setDelegate:(id)delegate;

@end
