//
//  SDKCore.h
//  WazzaSDK
//
//  Created by Joao Luis Vazao Vasques on 16/10/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetworkService.h"
#import "SecurityService.h"
#import "PersistenceService.h"
#import "PurchaseService.h"
#import "SessionInfo.h"
#import "LocationInfo.h"
#import "PurchaseDelegate.h"
#import "SessionService.h"
#import "LocationService.h"
#import "SDKCoreDelegate.h"

@interface SDKCore : NSObject

@property (nonatomic, weak) id<SDKCoreDelegate> delegate;
@property(nonatomic) NSString *companyName;
@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *secret;
@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;
@property(nonatomic, strong) PersistenceService *persistenceService;
@property(nonatomic, strong) PurchaseService *purchaseService;
@property(nonatomic, strong) SessionService *sessionService;
@property(nonatomic, strong) LocationService *locationService;
@property(nonatomic, strong) NSArray *skInfo;

-(id)initCore:(NSString *)companyName
             :(NSString *)applicationName
             :(NSString *)secretKey;


-(void)newSession;

-(void)resumeSession;

-(void)endSession;

#pragma Purchases functions

-(void)makePurchase:(NSString *)item;

#pragma Other stuff

-(void)allowGeoLocation;

-(void)setUserId:(NSString *)userId;

@end
