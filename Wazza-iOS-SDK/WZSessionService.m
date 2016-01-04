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


#import "WZSessionService.h"
#import "WZSessionInfo.h"
#import "WZNetworkService.h"
#import "WZSecurityService.h"
#import "WZPersistenceService.h"

#define ENDPOINT_SESSION_NEW @"session/new"

@interface WZSessionService ()

@property(nonatomic, strong) WZNetworkService *networkService;
@property(nonatomic, strong) WZSecurityService *securityService;
@property(nonatomic, strong) WZPersistenceService *persistenceService;
@property(nonatomic, strong) WZSessionInfo *currentSession;

@end

@implementation WZSessionService

-(id)initService:(NSString *)userId :(NSString *)token {
    
    self = [super init];
    
    if (self) {
        self.userId = userId;
        self.token = token;
        self.networkService = [[WZNetworkService alloc] initService];
        self.securityService = [[WZSecurityService alloc] init];
        self.persistenceService = [[WZPersistenceService alloc] initPersistence];
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
        self.currentSession = [[WZSessionInfo alloc] initSessionInfo :self.userId];
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

-(WZSessionInfo *)getCurrentSession {
    return (WZSessionInfo *)[self.persistenceService getContent:CURRENT_SESSION];
}

#pragma mark HTTP private methods

-(void)addPurchasesToCurrentSession:(NSString *)purchaseId {
    WZSessionInfo *session = [self getCurrentSession];
    [session addPurchaseId:purchaseId];
    self.currentSession = session;
    [self.persistenceService storeContent:self.currentSession :CURRENT_SESSION];
    NSMutableArray *savedSessions = [self.persistenceService getArrayContent:SESSION_INFO];
    NSMutableArray *newSessions = [[NSMutableArray alloc] init];
    for (__strong WZSessionInfo *s in savedSessions) {
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
    for(__strong WZSessionInfo* s in _saved) {
        [s setEndDate];
        [sessions addObject:[s toJson]];
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:sessions, @"session", nil];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/", URL, ENDPOINT_SESSION_NEW];
    NSString *content = [self createStringFromJSON:dic];
    NSDictionary *headers = [self addSecurityInformation:content];
    NSDictionary *requestData = [self createContentForHttpPost:content :requestUrl];
    
    [self.networkService sendData:
                       requestUrl:
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

-(NSDictionary *)createContentForHttpPost:(NSString *)content :(NSString *)requestUrl {
    NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:content,@"content", nil];
    return body;
}

-(NSDictionary *)addSecurityInformation:(NSString *)content {
    NSMutableDictionary *securityHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self token], @"SDK-TOKEN", nil];
    return securityHeaders;
}

@end
