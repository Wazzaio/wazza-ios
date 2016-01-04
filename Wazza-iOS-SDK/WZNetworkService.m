/*
 * wazza-ios
 * https://github.com/Wazzaio/wazza-ios
 * Copyright (C) 2013-2015  Duarte Barbosa, João Vazão Vasques
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#import "WZNetworkService.h"
#import "WZHttpCodes.h"
#import "AFHTTPRequestOperationManager.h"
#import "WZPersistenceService.h"

@interface WZNetworkService ()

@property (nonatomic, strong) dispatch_queue_t networkQueue;
@property(strong) WZPersistenceService *persistenceService;

@end

@implementation WZNetworkService

-(id)initService {
    self = [super init];
    
    if (self) {
        self.networkQueue = dispatch_queue_create("Wazza Network Queue", NULL);
        self.persistenceService = [[WZPersistenceService alloc] initPersistence];
    }
    
    return self;
}
-(void)sendData:(NSString *)url
               :(NSDictionary *)headers
               :(NSDictionary *)data
               :(OnSuccess)success
               :(OnFailure)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer = responseSerializer;
    
    for (NSString* headerId in headers) {
        [manager.requestSerializer setValue:[headers objectForKey:headerId] forHTTPHeaderField:headerId];
    }
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    dispatch_async(self.networkQueue, ^{
        [manager POST:[self escapeURL:url] parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }];
    });
    //    NSMutableURLRequest *request = [self buildRequest:url :httpMethod :params :headers :data];
    //
    //    dispatch_async(self.networkQueue, ^{
    //        [NSURLConnection sendAsynchronousRequest
    //         :request
    //         queue:[NSOperationQueue mainQueue]
    //         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    //             if (!error) {
    //                 NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //                 int httpCode = (int)[httpResponse statusCode];
    //                 if([WZHttpCodes isError:httpCode]) {
    //                     NSError *err = [NSError errorWithDomain:@"Http code" code:httpCode userInfo:nil];
    //                     dispatch_async(dispatch_get_main_queue(), ^{
    //                         failure(err);
    //                     });
    //                 } else {
    //                     dispatch_async(dispatch_get_main_queue(), ^{
    //                         success([self parseResponse:data :error]);
    //                     });
    //                 }
    //             } else {
    //                 dispatch_async(dispatch_get_main_queue(), ^{
    //                     failure(error);
    //                 });
    //             }
    //         }];
    //    });
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

+(NSDictionary *)createContentForHttpPost:(NSString *)content {
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    return body;
}

@end
