//
//  NetworkService.h
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_GET @"GET"
#define HTTP_POST @"POST"
#define URL @"http://192.168.1.65:9000/api/"

typedef void (^OnSuccess)(NSArray *);
typedef void (^OnFailure)(NSError *);

@interface NetworkService : NSObject

-(void)httpRequest:(NSString *)url
                  :(NSString *)httpMethod
                  :(NSDictionary *)params
                  :(NSDictionary *)headers
                  :(NSData *)data
                  :(OnSuccess)success
                  :(OnFailure)failure;
@end
