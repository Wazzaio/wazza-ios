//
//  SessionService.h
//  Sdk
//
//  Created by Joao Vasques on 26/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionInfo.h"

#define CURRENT_SESSION @"current_session"

@interface SessionService : NSObject

@property(nonatomic) NSString *companyName;
@property(nonatomic) NSString *applicationName;
@property(nonatomic) NSString *userId;

-(id)initService:(NSString *)companyName :(NSString *)applicationName :(NSString *)userId;

-(BOOL)anySessionStored;

-(void)initSession;

-(void)resumeSession;

-(void)endSession;

-(NSString *)getCurrentSessionHash;

-(SessionInfo *)getCurrentSession;

@end
