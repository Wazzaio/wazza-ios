//
//  SDK.m
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "WazzaSDK.h"
#import "NetworkService.h"
#import "SecurityService.h"
#import "PersistenceService.h"
#import "PurchaseService.h"
#import "ItemService.h"
#import "SessionInfo.h"
#import "LocationInfo.h"
#import "PurchaseDelegate.h"
#import "SessionService.h"
#import "LocationService.h"

#define ITEMS_LIST @"ITEMS LIST"
#define DETAILS @"DETAIILS"
#define PURCHASE @"PURCHASE"

#define HTTP_GET @"GET"
#define HTTP_POST @"POST"

//Server endpoints
#define ENDPOINT_AUTH @"auth"
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_ITEM_DETAILED_LIST @"items/details/"
#define ENDPOINT_DETAILS @"item/"
#define ENDPOINT_PURCHASE @"purchase"

@interface WazzaSDK() <PurchaseDelegate>

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

@end

@implementation WazzaSDK

@synthesize delegate;

-(id)initWithCredentials:(NSString *)companyName
                        :(NSString *)applicationName
                        :(NSString *)secretKey {
    
    self = [super init];
    
    if(self) {
        self.companyName = companyName;
        self.applicationName = applicationName;
        self.secret = secretKey;
        self.networkService = [[NetworkService alloc] init];
        self.securityService = [[SecurityService alloc] init];
        self.persistenceService = [[PersistenceService alloc] initPersistence];
        self.purchaseService = [[PurchaseService alloc] initWithAppName:companyName :applicationName];
        self.sessionService = [[SessionService alloc] initService:companyName :applicationName];
        self.purchaseService.delegate = self;
        self.locationService = nil;
        [self bootstrap];
    }
    
    return self;
}

-(void)allowGeoLocation {
    self.locationService = [[LocationService alloc] initService];
}

#pragma Session functions

-(void)newSession {
    [self.sessionService initSession];
}

//TODO: service's function is to be done
-(void)resumeSession {
    [self.sessionService resumeSession];
}

-(void)endSession {
    [self.sessionService endSession];
}

#pragma Purchases

-(void)makePurchase:(NSString *)item {

//    SKProduct *i = nil;
//    for (SKProduct *p in self.skInfo) {
//        if (p.productIdentifier == item._id) {
//            i = p;
//            break;
//        }
//    }
    
    [self.purchaseService purchaseItem:item];
}

#pragma mark HTTP private methods

-(NSString *)createStringFromJSON:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:0
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

-(NSData *)createContentForHttpPost:(NSString *)content :(NSString *)requestUrl {
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:body
                                                          options:0
                                                            error:&error];
    return requestData;
}

-(NSDictionary *)addSecurityInformation:(NSString *)content {
    NSMutableDictionary *securityHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self applicationName],@"AppName", nil];

    if (content) {
        [securityHeaders setValue:[self.securityService hashContent:content] forKey:@"Digest"];
    }
    return securityHeaders;
}

#pragma mark Init methods

-(void)bootstrap {
    [self newSession];
}

#pragma PurchaseDelegate

-(void)onPurchaseFailure:(WazzaError *)error {
    NSLog(@"received error...");
    NSError *err = nil;
    [self.delegate PurchaseFailure:err];
}


-(void)onPurchaseSuccess:(PurchaseInfo *)purchaseInfo {
    purchaseInfo.sessionHash = [self.sessionService getCurrentSessionHash];
    NSDictionary *json = [purchaseInfo toJson];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", URL, ENDPOINT_PURCHASE];
    NSString *content = [self createStringFromJSON:json];
    NSDictionary *headers = [self addSecurityInformation:content];
    NSDictionary *params = nil;
    NSData *requestData = [self createContentForHttpPost:content :requestUrl];

    [self.networkService httpRequest:
                          requestUrl:
                           HTTP_POST:
                              params:
                             headers:
                         requestData:
     ^(NSArray *result){
        NSLog(@"PURCHASE SUCCESS! %@", purchaseInfo);
        [self.delegate purchaseSuccess:purchaseInfo];
     }:
     ^(NSError *error){
        [self.delegate PurchaseFailure:error];
     }
     ];
}

@end
