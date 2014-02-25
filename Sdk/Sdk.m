//
//  SDK.m
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "SDK.h"
#import "NetworkService.h"

#define ITEMS_LIST @"ITEMS LIST"
#define DETAILS @"DETAIILS"
#define PURCHASE @"PURCHASE"

#define URL @"http://localhost:9000/api/"
#define HTTP_GET @"GET"
#define HTTP_POST @"POST"

//Server endpoints
#define ENDPOINT_ITEM_LIST @"items/"
#define ENDPOINT_DETAILS @"item/"
#define ENDPOINT_PURCHASE @"purchase/"

@interface SDK()

@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *secret;
@property(nonatomic, strong) NetworkService *networkService;

@end

@implementation SDK

-(id)initWithCredentials:(NSString *)name
                        :(NSString *)secretKey {
    
    self = [super init];
    
    if(self) {
        self.applicationName = name;
        self.secret = secretKey;
        self.networkService = [[NetworkService alloc] init];
    }
    
    return self;
}

-(NSDictionary *)getItems:(int)offset {
    
    NSString *requestUrl = [NSString stringWithFormat: @"%@%@%@", URL, ENDPOINT_ITEM_LIST, self.applicationName];;
    [self.networkService httpRequest:ASYNC :requestUrl :HTTP_GET :nil  completionBlock:^(NSArray *data, NSError *error){
        if (!error) {
            NSLog(@"DATA %@", data);
        } else {
            NSLog(@"has error: %@", error);
        }
    }];
    
    return Nil;
}

-(Item *)getItemDetails:(NSString *)id {
    return nil;
}

//-(NSArray *)fetchMoreItems;

-(void)makePurchase:(NSString *)itemId {
}


@end
