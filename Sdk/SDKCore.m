//
//  SDKCore.m
//  WazzaSDK
//
//  Created by Joao Luis Vazao Vasques on 16/10/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "SDKCore.h"
#import <UIKit/UIDevice.h>

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

@interface SDKCore () <PurchaseDelegate>

@end

@implementation SDKCore

@synthesize delegate;

-(id)initCore:(NSString *)token {

    self = [super init];
    
    if(self) {
        self.userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.secret = token;
        self.networkService = [[NetworkService alloc] init];
        self.securityService = [[SecurityService alloc] init];
        self.persistenceService = [[PersistenceService alloc] initPersistence];
        self.purchaseService = [[PurchaseService alloc] initService :self.userId];
        self.sessionService = [[SessionService alloc] initService :self.userId :token];
        self.purchaseService.delegate = self;
        self.locationService = nil;
        [self bootstrap];
    }
    
    return self;
}

#pragma mark Init methods
-(void)bootstrap {
    [self newSession];
}

-(void)newSession {
    [self.sessionService initSession];
}

-(void)resumeSession {
    [self.sessionService initSession];
}

-(void)endSession {
    [self.sessionService endSession];
}

-(void)makePurchase:(NSString *)item {
    [self.purchaseService purchaseItem:item];
}


#pragma Other stuff

-(void)allowGeoLocation {
    //TODO
}

//-(void)setUserId:(NSString *)_id {
//    self.userId = _id;
//    self.sessionService.userId = _id;
//    self.purchaseService.userId = _id;
//}

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

-(NSDictionary *)addSecurityInformation {
    NSMutableDictionary *securityHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self secret], @"SDK-TOKEN", nil];
    return securityHeaders;
}

#pragma PurchaseDelegate

-(void)onPurchaseFailure:(WazzaError *)error {
    NSLog(@"received error...");
    NSError *err = nil;
    [self.delegate corePurchaseFailure:err];
}


-(void)onPurchaseSuccess:(PurchaseInfo *)purchaseInfo {
    purchaseInfo.sessionHash = [self.sessionService getCurrentSessionHash];
    [self.sessionService addPurchasesToCurrentSession:purchaseInfo._id];
    NSDictionary *json = [purchaseInfo toJson];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/", URL, ENDPOINT_PURCHASE];
    NSString *content = [self createStringFromJSON:json];
    NSDictionary *headers = [self addSecurityInformation];
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
         [self.delegate corePurchaseSuccess:purchaseInfo];
     }:
     ^(NSError *error){
         [self.delegate corePurchaseFailure:error];
     }
     ];
}


@end
