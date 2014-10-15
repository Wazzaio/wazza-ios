//
//  NetworkService.m
//  SDK
//
//  Created by Joao Vasques on 25/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "NetworkService.h"
#import "HttpCodes.h"

@implementation NetworkService

-(void)httpRequest:(NSString *)url
                  :(NSString *)httpMethod
                  :(NSDictionary *)params
                  :(NSDictionary *)headers
                  :(NSData *)data
                  :(OnSuccess)success
                  :(OnFailure)failure
{
    NSMutableURLRequest *request = [self buildRequest:url :httpMethod :params :headers :data];
    [NSURLConnection sendAsynchronousRequest
     :request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         if (!error) {
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             int httpCode = (int)[httpResponse statusCode];
             if([HttpCodes isError:httpCode]) {
                 NSError *err = [NSError errorWithDomain:@"Http code" code:httpCode userInfo:nil];
                 failure(err);
             } else {
                 success([self parseResponse:data :error]);
             }
         } else {
             failure(error);
         }
     }];
}

#pragma mark Private Functions

-(NSString *)escapeURL:(NSString *)url {
    NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)url, NULL, CFSTR(" "), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString) {
        return newString;
    } else {
        return @"";
    }
}

-(NSArray *)parseResponse: (NSData *)data :(NSError *)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

-(NSMutableURLRequest *)buildRequest:(NSString *)url
                                    :(NSString *)httpMethod
                                    :(NSDictionary *)params
                                    :(NSDictionary *)headers
                                    :(NSData *)data {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self escapeURL:url]]];
    [request setHTTPMethod:httpMethod];
    
    if ([httpMethod isEqualToString:HTTP_POST]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: data];
    }
    
    void(^addHeaders)(NSDictionary *) = ^(NSDictionary *h) {
        if (h) {
            NSMutableArray *keys = [[h allKeys] mutableCopy];
            for (NSString *key in keys) {
                [request setValue:[h objectForKey:key] forHTTPHeaderField:key];
            }
        }
    };
    
    addHeaders(params);
    addHeaders(headers);
    
    return request;
}

@end
