//
//  SessionService.h
//  Sdk
//
//  Created by Joao Vasques on 26/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionService : NSObject

@property(nonatomic) NSString *companyName;
@property(nonatomic) NSString *applicationName;

-(id)initService:(NSString *)companyName :(NSString *)applicationName;

-(BOOL)anySessionStored;

-(void)initSession;

-(void)resumeSession;

-(void)endSession;

-(NSString *)getCurrentSessionHash;

@end
