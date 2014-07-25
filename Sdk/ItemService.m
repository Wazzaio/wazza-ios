//
//  ItemService.m
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//
#import <StoreKit/StoreKit.h>

#import "ItemService.h"
#import "Item.h"
#import "PersistenceService.h"
#import "SecurityService.h"
#import "NetworkService.h"
#define URL @"http://localhost:9000/api/"

#define ENDPOINT_AUTH @"auth"
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_ITEM_DETAILED_LIST @"items/details/"
#define ENDPOINT_RECOMMENDATION @"rec/user/items/"

@interface ItemService () <SKProductsRequestDelegate>

@property(nonatomic, strong) SKProductsRequest *productRequest;
@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;
@property(nonatomic, strong) PersistenceService *persistenceService;
@property(nonatomic, strong) NSArray *validSKProducts;

@end

@implementation ItemService

@synthesize delegate;

-(id)initWithAppName:(NSString *)companyName :(NSString *)applicationName {
    self = [super init];
    if (self) {
        self.companyName = companyName;
        self.applicationName = applicationName;
        self.persistenceService = [[PersistenceService alloc] init];
        self.networkService = [[NetworkService alloc] init];
        self.securityService = [[SecurityService alloc] init];
    }

    return self;
}

-(NSArray *)getRecommendedItems:(int)limit
                               :(OnSuccess)success
                               :(OnFailure)failure {
    NSString *userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *requestUrl = [NSString stringWithFormat: @"%@%@%@/%@/%@/%d",
                            URL,
                            ENDPOINT_RECOMMENDATION,
                            self.companyName,
                            self.applicationName,
                            userId,
                            limit];

    NSDictionary *headers = [self addSecurityInformation:nil];
    
    [self.networkService
     httpRequest:
     requestUrl:
     HTTP_GET:
     nil:
     headers:
     nil:
     ^(NSArray *result){
         success(result);
     }:
     ^(NSError *error){
         failure(error);
     }
     ];
    
    return nil;
}

-(void)fetchItems:(int)offset {
    
//    NSString *requestUrl = [NSString stringWithFormat: @"%@%@%@", URL, ENDPOINT_ITEM_DETAILED_LIST, self.applicationName];
//    NSDictionary *headers = [self addSecurityInformation:nil];
//    
//    [self.networkService
//     httpRequest:
//     requestUrl:
//     HTTP_GET:
//     nil:
//     headers:
//     nil:
//     ^(NSArray *result){
//         NSMutableSet *productsId = [[NSMutableSet alloc] init];
//         for (id item in result) {
//             [self.persistenceService createItemFromJson:item];
//             [productsId addObject:[self getItemIdFromJson:item]];
//         }
//         [self checkValidity:productsId];
//     }:
//     ^(NSError *result){
//         WazzaError *error = [[WazzaError alloc] initWithMessage:@"error"]; //TODO
//         [self.delegate onItemFetchComplete:nil :error];
//     }
//     ];
}

-(NSString *)getItemIdFromJson:(NSDictionary *) jsonItem {
    NSLog(@"%@", jsonItem);
    return [[jsonItem valueForKey:@"metadata"] valueForKey:@"itemId"];
}

-(Item *)getItem:(NSString *)name {
    return Nil;
//    return [self.persistenceService getItem:name];
}

-(NSArray *)getItems:(int)offset {
    return Nil;
//    return[self.persistenceService getItems:offset];
}

#pragma mark Private Functions

-(NSDictionary *)addSecurityInformation:(NSString *)content {
    NSMutableDictionary *securityHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self applicationName],@"AppName", nil];
    
    if (content) {
        [securityHeaders setValue:[self.securityService hashContent:content] forKey:@"Digest"];
    }
    return securityHeaders;
}

-(void)checkValidity:(NSSet *)productIdentifiers {
    self.productRequest = [[SKProductsRequest alloc]
                           initWithProductIdentifiers:productIdentifiers];
    self.productRequest.delegate = self;
    [self.productRequest start];
}

#pragma SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response {
//    
//    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
//        [self.persistenceService removeItem:invalidIdentifier];
//    }
//    
//    [self.delegate onItemFetchComplete:response.products :nil];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    WazzaError *err = [[WazzaError alloc] initWithMessage:[[error userInfo] objectForKey:@"NSLocalizedDescription"]];
    [self.delegate onItemFetchComplete:nil :err];
}

@end
