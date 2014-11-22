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

#define ENDPOINT_SESSION_NEW @"session/new"

@interface SessionService ()

@property(nonatomic, strong) NetworkService *networkService;
@property(nonatomic, strong) SecurityService *securityService;
@property(nonatomic, strong) PersistenceService *persistenceService;
@property(nonatomic, strong) SessionInfo *currentSession;

@end

@implementation SessionService

-(id)initService:(NSString *)userId :(NSString *)token {
    
    self = [super init];

    if (self) {
        self.userId = userId;
        self.token = token;
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
        self.currentSession = [[SessionInfo alloc] initSessionInfo :self.userId];
        [self.persistenceService addContentToArray:self.currentSession :SESSION_INFO];
        [self.persistenceService storeContent:self.currentSession :CURRENT_SESSION];
    }
}

//TODO
-(void)resumeSession {
    [self initSession];
    /**
        In the future check if N seconds have passed since the last session took place.
        For now flushes session's data to server and creates a new one
    **/
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

-(void)addPurchasesToCurrentSession:(NSString *)purchaseId {
    SessionInfo *session = [self getCurrentSession];
    [session addPurchaseId:purchaseId];
    self.currentSession = session;
    [self.persistenceService storeContent:self.currentSession :CURRENT_SESSION];
    NSMutableArray *savedSessions = [self.persistenceService getArrayContent:SESSION_INFO];
    NSMutableArray *newSessions = [[NSMutableArray alloc] init];
    for (__strong SessionInfo *s in savedSessions) {
        if ([s.sessionHash isEqualToString:self.currentSession.sessionHash]) {
            [newSessions addObject:self.currentSession];
        } else {
            [newSessions addObject:s];
        }
    }
    [self.persistenceService storeContent:newSessions :SESSION_INFO];
}

-(void)sendSessionDataToServer {
    NSMutableArray *sessions = [[NSMutableArray alloc] init];
    NSMutableArray *_saved = [self.persistenceService getArrayContent:SESSION_INFO];
    for(__strong SessionInfo* s in _saved) {
        [s setEndDate];
        [sessions addObject:[s toJson]];
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sessions, @"session", nil];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/", URL, ENDPOINT_SESSION_NEW];
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
    NSMutableDictionary *securityHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self token], @"SDK-TOKEN", nil];
    return securityHeaders;
}

@end
