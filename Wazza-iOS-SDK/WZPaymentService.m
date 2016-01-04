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


#import "WZPaymentService.h"
#import "WZPaymentRequest.h"
#import "WZInAppPurchasePaymentRequest.h"
#import "WZPayPalPaymentRequest.h"
#import "WZPaymentInfo.h"
#import "WZNetworkService.h"
#import "WZSecurityService.h"

#define SUBMIT_PAYMENT_URL @"purchase"

@interface WZPaymentService ()

@property(strong) NSString *_sdkToken;
@property(strong) NSString *userId;
@property(strong) WZNetworkService *networkService;

@end

@implementation WZPaymentService

@synthesize delegate;

-(instancetype)initPaymentService:(NSString *)sdkToken :(NSString *)userId {
    
    self = [super init];
    
    if (self) {
        self._sdkToken = sdkToken;
        self.userId = userId;
        self.iapService = [[WZInAppPurchaseService alloc] initService:userId :sdkToken];
        self.iapService.delegate = self;
        self.networkService = [[WZNetworkService alloc] initService];
    }
    
    return self;
}

-(void)makePayment:(WZPaymentRequest *)info {
    if ([info isMemberOfClass:[WZInAppPurchasePaymentRequest class]]) {
        [self.iapService makePayment:(WZInAppPurchasePaymentRequest *)info];
    } else if ([info isMemberOfClass:[WZPayPalPaymentRequest class]]) {
        [self.payPalService makePayment:(WZPayPalPaymentRequest *)info];
    }
}

#pragma PayPal functions

/**
 *  Description
 *
 *  @param productionClientID <#productionClientID description#>
 *  @param sandboxClientID    <#sandboxClientID description#>
 *  @param APIClientID        <#APIClientID description#>
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
                           :(BOOL)testFlag {
    if (self._sdkToken != nil) {
        self.payPalService = [[WZPayPalService alloc] initService:self._sdkToken
                                                                 :self.userId
                                                                 :productionClientID
                                                                 :sandboxClientID
                                                                 :APIClientID
                                                                 :APISecret
                                                                 :merchantName
                                                                 :privacyPolicyURL
                                                                 :userAgreementURL
                                                                 :acceptCreditCards
                                                                 :testFlag];
        self.payPalService.delegate = self;
    } else {
        NSLog(@"Need to call initPaymentService first");
        [NSException raise:@"PayPal module not initialized" format:@"Need to call init PayPal first"];
    }
}

/**
 *  <#Description#>
 *
 *  @param view <#view description#>
 */
-(void)connectToPayPal:(UIViewController *)view {
    self.payPalService != nil ? [self.payPalService connect:view] : NSLog(@"");
}

#pragma WZPaymentSystemsDelegate

/**
 *  <#Description#>
 */
-(void)paymentSuccess:(WZPaymentInfo *)info {
    NSDictionary *content = [info toJson];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/", URL, SUBMIT_PAYMENT_URL];
    NSDictionary *headers = [WZSecurityService addSecurityInformation:self._sdkToken];
    [self.networkService sendData:requestUrl:
                          headers:
                          content:
     ^(NSArray *result){
         NSLog(@"RESULT OK");
         [self.delegate onPurchaseSuccess:info];
     }:
     ^(NSError *error){
         NSLog(@"%@", error);
         [self.delegate onPurchaseFailure:[[WZError alloc]initWithMessage:error.description]];
     }
     ];
}

/**
 *  <#Description#>
 */
-(void)paymentFailure:(NSError *)error {
    NSLog(@"PAYMENT ERROR:");
    [self.delegate onPurchaseFailure:[[WZError alloc]initWithMessage:error.description]];
}

@end
