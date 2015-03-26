//
//  Wazza_iOS_SDK.m
//  Wazza-iOS-SDK
//
//  Created by Joao Luis Vazao Vasques on 17/03/15.
//  Copyright (c) 2015 Wazza. All rights reserved.
//

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
    (_core == nil) ? NSLog(@"") : [_core newSession];
}

+(void)resumeSession {
    (_core == nil) ? NSLog(@"") : [_core resumeSession];
}

+(void)endSession {
    (_core == nil) ? NSLog(@"") : [_core endSession];
}

#pragma Payments functions

+(void)makePayment:(WZPaymentRequest *)info {
    (_core == nil) ? NSLog(@"") : [_core makePayment:info];
}

#pragma PayPal logic

+(void)connectToPayPal:(UIViewController *)currentView {
    (_core == nil) ? NSLog(@"") : [_core.paymentService connectToPayPal:currentView];
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
    (_core == nil) ? NSLog(@"") : [_core initPayPalService:productionClientID :sandboxClientID :APIClientID :APISecret :merchantName :privacyPolicyURL :userAgreementURL : acceptCreditCards :testFlag];
}

#pragma Other stuff

+(void)allowGeoLocation {
    (_core == nil) ? NSLog(@"") : [_core allowGeoLocation];
}

+(void)setPurchaseDelegate:(id)delegate {
    _delegate = delegate;
}

#pragma SDKCore Delegate methods

+(void)corePurchaseSuccess:(WZPaymentInfo *)info {
    (_delegate != nil) ? [_delegate purchaseSuccess:info] : NSLog(@"");
}

+(void)corePurchaseFailure:(NSError *)error {
    (_delegate != nil) ? [_delegate PurchaseFailure:error]: NSLog(@"");
}

@end
