//
//  SDK.m
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "SDK.h"
#import "NetworkService.h"
#import "SecurityService.h"

#define ITEMS_LIST @"ITEMS LIST"
#define DETAILS @"DETAIILS"
#define PURCHASE @"PURCHASE"

#define URL @"http://localhost:9000/api/"
#define HTTP_GET @"GET"
#define HTTP_POST @"POST"

//Server endpoints
#define ENDPOINT_AUTH @"auth"
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_DETAILS @"item/"
#define ENDPOINT_PURCHASE @"purchase/"

@interface SDK()

@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *secret;
@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;

@end

@implementation SDK

-(id)initWithCredentials:(NSString *)name
                        :(NSString *)secretKey {
    
    self = [super init];
    
    if(self) {
        self.applicationName = name;
        self.secret = secretKey;
        self.networkService = [[NetworkService alloc] init];
        self.securityService = [[SecurityService alloc] init];
        if (![self authenticateTest]) {
            self = nil;
        } else {
            [self fetchItems:0];
        }
    }
    
    return self;
}


-(NSDictionary *)getItems:(int)offset {
    return nil;
}


-(Item *)getItemDetails:(NSString *)id {
    return nil;
}


-(void)makePurchase:(NSString *)itemId {
}

/********** PRIVATE FUNCTIONS ********/

-(NSDictionary *)addSecurityInformation:(NSString *)content {
    NSMutableDictionary *securityHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self applicationName],@"AppName", nil];

    if (content) {
        [securityHeaders setValue:[self.securityService hashContent:content] forKey:@"Digest"];
    }
    return securityHeaders;
}

//just for test now..
-(BOOL)authenticateTest {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", URL, ENDPOINT_AUTH];
    NSString *content = @"hello world";
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    NSDictionary *headers = [self addSecurityInformation:content];
    NSDictionary *params = nil;
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:body
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:&error];
    __block BOOL retVal = NO;
    
    [self.networkService
     httpRequest:
     SYNC:
     requestUrl:
     HTTP_POST:
     params:
     headers:
     requestData:
     ^(NSArray *result){
         retVal = YES;
     }:
     ^(NSError *result){
         retVal = NO;
     }
     ];
    
    return retVal;
}

-(void)fetchItems:(int)offset {
    NSString *requestUrl = [NSString stringWithFormat: @"%@%@%@", URL, ENDPOINT_ITEM_LIST, self.applicationName];
    NSDictionary *headers = [self addSecurityInformation:nil];
    
    [self.networkService
     httpRequest:
     SYNC:
     requestUrl:
     HTTP_GET:
     nil:
     headers:
     nil:
     ^(NSArray *result){
         NSLog(@"add items to memory");
         NSLog(@"%@", result);
     }:
     ^(NSError *result){
         NSLog(@"oops.. something went wrong");
     }
     ];
}

@end
