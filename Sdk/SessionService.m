//
//  SessionService.m
//  Sdk
//
//  Created by Joao Vasques on 26/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "SessionService.h"
#import "SessionInfo.h"
#import "NetworkService.h"
#import "SecurityService.h"
#import "PersistenceService.h"

#define URL @"http://localhost:9000/api/"
#define ENDPOINT_SESSION_NEW @"session/new"

@interface SessionService ()

@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;
@property(nonatomic, strong) PersistenceService *persistenceService;
@property(nonatomic, strong) SessionInfo *currentSession;

@end

@implementation SessionService

-(id)initService:(NSString *)companyName :(NSString *)applicationName {
    
    self = [super init];

    if (self) {
        self.companyName = companyName;
        self.applicationName = applicationName;
        self.networkService = [[NetworkService alloc] init];
        self.securityService = [[SecurityService alloc] init];
        self.persistenceService = [[PersistenceService alloc] initPersistence];
    }
    
    return self;
}

-(BOOL)anySessionStored {
    return [self.persistenceService contentExists:SESSION_INFO];
}

-(void)initSession{
    self.currentSession = [[SessionInfo alloc] initSessionInfo:self.applicationName : self.companyName];
    [self.persistenceService storeContent: self.currentSession :SESSION_INFO];
}

//TODO
-(void)resumeSession {
    SessionInfo *session = [self.persistenceService getContent:SESSION_INFO];
    NSDate *currentDate = [NSDate date];
    
    NSLog(@"Session %@", session);
    NSLog(@"current date %@", currentDate);
}

-(void)endSession {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@/%@", URL, ENDPOINT_SESSION_NEW, @"companyName", self.applicationName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    
    SessionInfo *sessionInfo =(SessionInfo *)[self.persistenceService getContent:SESSION_INFO];
    [sessionInfo setEndDate];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[sessionInfo toJson], @"session", nil];
    NSString *content = [self createStringFromJSON:dic];
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
         NSLog(@"session update ok");
         [self.persistenceService clearContent:SESSION_INFO];
     }:
     ^(NSError *error){
         NSLog(@"%@", error);
     }
     ];
}

-(NSString *)getCurrentSessionHash {
    return self.currentSession.sessionHash;
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

@end
