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


#import "WZPersistenceService.h"

@implementation WZPersistenceService

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