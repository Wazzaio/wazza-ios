//
//  PersistenceService.m
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "PersistenceService.h"

@implementation PersistenceService

-(id)initPersistence {
    self = [super init];
    if (self) {
        if (![self contentExists:SESSION_INFO]) {
            NSData *sessions = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
            [[NSUserDefaults standardUserDefaults] setObject:sessions forKey:SESSION_INFO];
        }
        if (![self contentExists:PURCHASE_INFO]) {
            NSData *purchases = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
            [[NSUserDefaults standardUserDefaults] setObject:purchases forKey:SESSION_INFO];
        }
    }
    return self;
}

-(void)storeContent:(id)content :(NSString *)key {
    
    NSData *_savedData = [NSKeyedArchiver archivedDataWithRootObject:content];
    [[NSUserDefaults standardUserDefaults] setObject:_savedData forKey:key];
}

-(NSMutableArray *)getArrayContent:(NSString *)arrayKey {
    NSData *array = [[NSUserDefaults standardUserDefaults] objectForKey:arrayKey];
    if (array) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:array];
    } else {
        return NULL;
    }
}

-(void)addContentToArray:(id)content :(NSString *)arrayKey {
    NSMutableArray *array = [self getArrayContent:arrayKey];
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    [array addObject:content];
    NSData *updated = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:updated forKey:arrayKey];
}

-(id)getContent:(NSString *)key {
    NSUserDefaults *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data != NULL) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return nil;
    }
}

-(BOOL)contentExists:(NSString *)key {
    BOOL res = false;
    id content = [self getContent:key];
    if (content != NULL) {
        if ([content isKindOfClass:[NSMutableArray class]]) {
            if([(NSMutableArray *)content count] > 0) {
                res = true;
            }
        } else {
            res = true;
        }
    }
    
    return res;
}

-(void)clearContent:(NSString *)key {
    if ([self contentExists:key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

@end
