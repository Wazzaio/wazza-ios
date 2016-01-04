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

#import "WZNetworkService.h"
#import "WZSecurityService.h"
#import "WZPersistenceService.h"
#import "WZInAppPurchaseService.h"
#import "WZSessionInfo.h"
#import "WZLocationInfo.h"
#import "WZPaymentDelegate.h"
#import "WZSessionService.h"
#import "WZLocationService.h"
#import "WZCoreDelegate.h"
#import "WZPaymentService.h"
#import "WZPaymentInfo.h"
#import "WZPaymentRequest.h"

@interface WZCore : NSObject

@property(nonatomic, weak) id<WZCoreDelegate> delegate;
@property(nonatomic) NSString *secret;
@property(nonatomic) NSString *userId;
@property(nonatomic, strong) WZNetworkService *networkService;
@property(nonatomic, strong) WZSecurityService *securityService;
@property(nonatomic, strong) WZPersistenceService *persistenceService;
@property(nonatomic, strong) WZInAppPurchaseService *purchaseService;
@property(nonatomic, strong) WZSessionService *sessionService;
@property(nonatomic, strong) WZLocationService *locationService;
@property(nonatomic, strong) NSArray *skInfo;
@property(atomic, strong) WZPaymentService *paymentService;

-(instancetype)initCore:(NSString *)secretKey;

-(instancetype)initCore:(NSString *)secretKey andUserId:(NSString *)userId;

-(void)newSession;

-(void)resumeSession;

-(void)endSession;

#pragma Payments functions

/**
 *  <#Description#>
 *
 *  @param info <#info description#>
 */
-(void)makePayment:(WZPaymentRequest *)info;

#pragma PayPal logic

-(void)initPayPalService:(NSString *)productionClientID
                        :(NSString *)sandboxClientID
                        :(NSString *)APIClientID
                        :(NSString *)APISecret
                        :(NSString *)merchantName
                        :(NSString *)privacyPolicyURL
                        :(NSString *)userAgreementURL
                        :(BOOL)acceptCreditCards
                        :(BOOL)testFlag;

-(void)connectToPayPal:(UIViewController *)currentView;

#pragma Other stuff

-(void)allowGeoLocation;

//-(void)setUserId:(NSString *)userId;

@end