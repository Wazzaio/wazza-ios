//
//  SDK.m
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SDK.h"
#import "NetworkService.h"
#import "SecurityService.h"
#import "PersistenceService.h"
#import "PurchaseService.h"
#import "ItemService.h"
#import "SessionInfo.h"
#import "LocationInfo.h"
#import "PurchaseDelegate.h"
#import "SessionService.h"

#define ITEMS_LIST @"ITEMS LIST"
#define DETAILS @"DETAIILS"
#define PURCHASE @"PURCHASE"

#define URL @"http://localhost:9000/api/"
#define HTTP_GET @"GET"
#define HTTP_POST @"POST"

//Server endpoints
#define ENDPOINT_AUTH @"auth"
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_ITEM_DETAILED_LIST @"items/details/"
#define ENDPOINT_DETAILS @"item/"
#define ENDPOINT_PURCHASE @"purchase"

@interface SDK() <CLLocationManagerDelegate, PurchaseDelegate>

@property(nonatomic) NSString *companyName;
@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *secret;
@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;
@property(nonatomic, strong) PersistenceService *persistenceService;
@property(nonatomic, strong) CLLocationManager *manager;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic, strong) LocationInfo *currentLocation;
@property(nonatomic, strong) PurchaseService *purchaseService;
@property(nonatomic, strong) SessionService *sessionService;
@property(nonatomic, strong) NSArray *skInfo;

@end

@implementation SDK

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
        self.currentLocation = nil;
        [self bootstrap];
    }
    
    return self;
}

-(void)allowGeoLocation {
    self.currentLocation = nil;
    if ([self isLocationServiceAvailable]) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.manager startUpdatingLocation];
    }
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

-(void)makePurchase:(Item *)item {

    SKProduct *i = nil;
    for (SKProduct *p in self.skInfo) {
        if (p.productIdentifier == item._id) {
            i = p;
            break;
        }
    }
    
    [self.purchaseService purchaseItem:i];
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

#pragma mark LocationManager

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Cannot get location: %@", error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    CLLocation *loc = newLocation;
    
    if (loc != nil) {
        NSNumber *latitude = [[NSNumber alloc] initWithDouble:loc.coordinate.latitude];
        NSNumber *longitude = [[NSNumber alloc] initWithDouble:loc.coordinate.longitude];
        self.currentLocation = [[LocationInfo alloc] initWithLocationData:[latitude doubleValue] :[longitude doubleValue]];
    }
    
}

-(BOOL)isLocationServiceAvailable
{
    if([CLLocationManager locationServicesEnabled]==NO ||
       [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
        return NO;
    }else{
        return YES;
    }
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
