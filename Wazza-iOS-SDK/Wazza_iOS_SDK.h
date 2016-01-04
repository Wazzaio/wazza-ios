/*
 * wazza-ios
 * https://github.com/Wazzaio/wazza-ios
 * Copyright (C) 2013-2015  Duarte Barbosa, João Vazão Vasques
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#import <Foundation/Foundation.h>
#import "WZCoreDelegate.h"
#import "WZPaymentRequest.h"
#import "WZPayPalPaymentRequest.h"
#import "WZInAppPurchasePaymentRequest.h"

@interface Wazza_iOS_SDK : NSObject <WZCoreDelegate>

/**
 *  Inits Wazza using a secret token
 *
 *  @param secretToken
 */
+(void)initWithSecret:(NSString *)secretToken;


/**
 *  Inits Wazza with secret token and user Id
 *
 *  @param secretToken unique token for authentication
 *  @param userId      unique user ID
 */
+(void)initWithSecret:(NSString *)secretToken andUserId:(NSString *)userId;

#pragma Session functions

/**
 *  Creates a new session and stores it locally
 */
+(void)newSession;


/**
 *  Sends the current session to the server
 *  TODO: write when to call this
 */
+(void)endSession;

#pragma Payments functions

/**
 *  <#Description#>
 *
 *  @param info <#info description#>
 */
+(void)makePayment:(WZPaymentRequest *)info;


#pragma PayPal logic

+(void)connectToPayPal:(UIViewController *)currentView;

+(void)initPayPalModule:(NSString *)productionClientID
                       :(NSString *)sandboxClientID
                       :(NSString *)APIClientID
                       :(NSString *)APISecret
                       :(NSString *)merchantName
                       :(NSString *)privacyPolicyURL
                       :(NSString *)userAgreementURL
                       :(BOOL)acceptCreditCards
                       :(BOOL)testFlag;

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
+(void)setPaymentDelegate:(id)delegate;


@end
