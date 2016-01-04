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
#import "WZPayPalService.h"
#import "WZInAppPurchaseService.h"
#import "WZPaymentRequest.h"
#import "WZPaymentSystemsDelegate.h"

@interface WZPaymentService : NSObject <WZPaymentSystemsDelegate>

@property(strong) WZPayPalService *payPalService;
@property(strong) WZInAppPurchaseService *iapService;

/**
 *  Delegate to send results to Core module
 */
@property (nonatomic, weak) id<WZPaymentDelegate> delegate;

/**
 *  <#Description#>
 *
 *  @param sdkToken <#sdkToken description#>
 *  @param userId   <#userId description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initPaymentService:(NSString *)sdkToken :(NSString *)userId;


/**
 *  <#Description#>
 *
 *  @param info <#info description#>
 */
-(void)makePayment:(WZPaymentRequest *)info;

/**
 *  <#Description#>
 *
 *  @param productionClientID <#productionClientID description#>
 *  @param sandboxClientID    sandboxClientID description
 *  @param APIClientID        APIClientID description
 *  @param APISecret          <#APISecret description#>
 *  @param merchantName       <#merchantName description#>
 *  @param privacyPolicyURL   <#privacyPolicyURL description#>
 *  @param userAgreementURL   <#userAgreementURL description#>
 *  @param acceptCreditCards  <#acceptCreditCards description#>
 *  @param testFlag           <#testFlag description#>
 */
-(void)activatePayPalModule:(NSString *)productionClientID
                           :(NSString *)sandboxClientID
                           :(NSString *)APIClientID
                           :(NSString *)APISecret
                           :(NSString *)merchantName
                           :(NSString *)privacyPolicyURL
                           :(NSString *)userAgreementURL
                           :(BOOL)acceptCreditCards
                           :(BOOL)testFlag;

/**
 *  <#Description#>
 *
 *  @param view <#view description#>
 */
-(void)connectToPayPal:(UIViewController *)view;

@end
