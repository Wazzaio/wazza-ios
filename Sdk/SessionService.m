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

#define URL @"http://wazza-api.cloudapp.net/api/"
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
    if ([self anySessionStored]) {
        [self sendSessionDataToServer];
    } else {
        self.currentSession = [[SessionInfo alloc] initSessionInfo:self.applicationName : self.companyName];
        [self.persistenceService addContentToArray:self.currentSession :SESSION_INFO];
        [self.persistenceService storeContent:self.currentSession :CURRENT_SESSION];
    }
}

//TODO
-(void)resumeSession {
    SessionInfo *session = [self.persistenceService getContent:SESSION_INFO];
    NSDate *currentDate = [NSDate date];
    
    NSLog(@"Session %@", session);
    NSLog(@"current date %@", currentDate);
}

-(void)endSession {
    [self sendSessionDataToServer];
}

-(NSString *)getCurrentSessionHash {
    return self.currentSession.sessionHash;
}

-(SessionInfo *)getCurrentSession {
    return (SessionInfo *)[self.persistenceService getContent:CURRENT_SESSION];
}

#pragma mark HTTP private methods

-(int)addPurchasesToCurrentSession {
    NSMutableArray *purchases = [self.persistenceService getArrayContent:PURCHASE_INFO];
    if (purchases != NULL) {
        self.currentSession.purchases = purchases;
        return (int)[purchases count];
    } else return  -1;
}

-(void)sendSessionDataToServer {
    NSMutableArray *sessions = [[NSMutableArray alloc] init];
    NSMutableArray *_saved = [self.persistenceService getArrayContent:SESSION_INFO];
    for(__strong SessionInfo* s in _saved) {
        if ([self.currentSession.startTime compare:s.startTime] == NSOrderedSame) {
            s = ([self addPurchasesToCurrentSession] > 0)? self.currentSession : s;
        }
        [s setEndDate];
        [sessions addObject:[s toJson]];
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sessions, @"session", nil];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/%@/%@", URL, ENDPOINT_SESSION_NEW, @"companyName", self.applicationName];
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
         [self.persistenceService clearContent:CURRENT_SESSION];
         [self.persistenceService clearContent:PURCHASE_INFO];
     }:
     ^(NSError *error){
         NSLog(@"%@", error);
     }
     ];
}

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
