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


#import "WZCore.h"
#import "Wazza_iOS_SDK.h"
#import "WazzaDelegate.h"

static WZCore *_core = nil;
static id<WazzaDelegate> _delegate = nil;

@implementation Wazza_iOS_SDK

+(void)initWithSecret:(NSString *)secretToken {
    [self coreInit:secretToken :nil];
}

+(void)initWithSecret:(NSString *)secretToken andUserId:(NSString *)userId {
    [self coreInit:secretToken :userId];
}

+(void)coreInit:(NSString *)secretToken :(NSString *)userId {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _core = (userId == nil) ? [[WZCore alloc] initCore:secretToken] : [[WZCore alloc] initCore:secretToken andUserId:userId];
        _core.delegate = [Wazza_iOS_SDK class];
    });
}

#pragma Session functions

+(void)newSession {
    (_core == nil) ? [self coreModuleNotInitialized] : [_core newSession];
}

+(void)resumeSession {
    (_core == nil) ? [self coreModuleNotInitialized] : [_core resumeSession];
}

+(void)endSession {
    (_core == nil) ? [self coreModuleNotInitialized] : [_core endSession];
}

#pragma Payments functions

+(void)makePayment:(WZPaymentRequest *)info {
    (_core == nil) ? [self coreModuleNotInitialized] : [_core makePayment:info];
}

#pragma PayPal logic

+(void)connectToPayPal:(UIViewController *)currentView {
    (_core == nil) ? [self coreModuleNotInitialized] : [_core.paymentService connectToPayPal:currentView];
}

+(void)initPayPalModule:(NSString *)productionClientID
                       :(NSString *)sandboxClientID
                       :(NSString *)APIClientID
                       :(NSString *)APISecret
                       :(NSString *)merchantName
                       :(NSString *)privacyPolicyURL
                       :(NSString *)userAgreementURL
                       :(BOOL)acceptCreditCards
                       :(BOOL)testFlag {
    (_core == nil) ? [self coreModuleNotInitialized] : [_core initPayPalService:productionClientID :sandboxClientID :APIClientID :APISecret :merchantName :privacyPolicyURL :userAgreementURL : acceptCreditCards :testFlag];
}

#pragma Other stuff

+(void)allowGeoLocation {
    (_core == nil) ? [self coreModuleNotInitialized] : [_core allowGeoLocation];
}

+(void)setPaymentDelegate:(id)delegate {
    _delegate = delegate;
}

+(void)coreModuleNotInitialized {
    NSLog(@"Wazza not initialized");
    [NSException raise:@"Wazza not initialized" format:@"Need to call Wazza init methods"];
}

#pragma SDKCore Delegate methods

+(void)corePurchaseSuccess:(WZPaymentInfo *)info {
    (_delegate != nil) ? [_delegate purchaseSuccess:info] : [self coreModuleNotInitialized];
}

+(void)corePurchaseFailure:(NSError *)error {
    (_delegate != nil) ? [_delegate PurchaseFailure:error]: [self coreModuleNotInitialized];
}

@end
