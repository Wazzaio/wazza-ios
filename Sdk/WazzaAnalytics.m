//
//  WazzaAnalytics.m
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "SDKCore.h"
#import "WazzaAnalytics.h"
#import "SDKCoreDelegate.h"
#import "WazzaDelegate.h"

@interface WazzaAnalytics() <SDKCoreDelegate>

@end

static SDKCore *_core = nil;
static id<WazzaDelegate> _delegate = nil;

@implementation WazzaAnalytics

+(void)initWithCredentials:(NSString *)companyName
                        :(NSString *)applicationName
                        :(NSString *)secretKey {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _core = [[SDKCore alloc] initCore:companyName :applicationName :secretKey];
        _core.delegate = [WazzaAnalytics class];
    });
}

#pragma Session functions

+(void)newSession {
    if (_core == nil) {
        
    } else {
        [_core newSession];
    }
}

+(void)resumeSession {
    if (_core == nil) {
        
    } else {
        [_core resumeSession];
    }
}

+(void)endSession {
    if (_core == nil) {
        
    } else {
        [_core endSession];
    }
}

#pragma Purchases functions

+(void)makePurchase:(NSString *)item {
    if (_core == nil) {
        
    } else {
        [_core makePurchase:item];
    }
}

#pragma Other stuff

+(void)allowGeoLocation {
    if (_core == nil) {
        
    } else {
        [_core allowGeoLocation];
    }
}

//+(void)setUserId:(NSString *)userId {
//    if (_core == nil) {
//        
//    } else {
//        [_core setUserId:userId];
//    }
//}

+(void)setDelegate:(id)delegate {
    _delegate = delegate;
}

#pragma SDKCore Delegate methods

+(void)corePurchaseSuccess:(PurchaseInfo *)info {
    NSLog(@"success");
    if(_delegate != nil) {
        [_delegate purchaseSuccess:info];
    } else {
        //TODO error log
    }
}

+(void)corePurchaseFailure:(NSError *)error {
    NSLog(@"Failure");
    if (_delegate != nil) {
        [_delegate PurchaseFailure:error];
    } else {
        //TODO error log
    }
}

@end
