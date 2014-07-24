//
//  PersistenceService.h
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "SessionInfo.h"

#define SESSION_INFO @"session_info"

@interface PersistenceService : NSObject

-(id)initPersistence;

//-(void)saveSessionInfo:(SessionInfo *)info;
//
//-(SessionInfo *)getSessionInfo;
//
//-(void)clearSession;

-(void)storeContent:(id)content :(NSString *)key;

-(id)getContent:(NSString *)key;

-(BOOL)contentExists:(NSString *)key;

-(void)clearContent:(NSString *)key;

//-(void)createItemFromJson:(NSDictionary *)json;
//
//-(Item *)getItem:(NSString *)name;
//
//-(void)removeItem:(NSString *)itemId;
//
//-(NSArray *)getItems:(int)offset;

@end
