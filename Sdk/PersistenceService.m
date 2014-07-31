//
//  PersistenceService.m
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "PersistenceService.h"
#import "Item.h"

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
        if([(NSMutableArray *)content count] > 0) {
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

//-(void)saveSessionInfo:(SessionInfo *)info {
//    NSData *_savedData = [NSKeyedArchiver archivedDataWithRootObject:info];
//    [[NSUserDefaults standardUserDefaults] setObject:_savedData forKey:SESSION_INFO];
//}
//
//-(SessionInfo *)getSessionInfo {
//    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:SESSION_INFO]];
//}
//
//-(void)clearSession {
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SESSION_INFO];
//}


//-(NSMutableArray *)getIdsList {
//    NSData *ids = [[NSUserDefaults standardUserDefaults] objectForKey:LIST_OF_ITEMS_IDS];
//    if (ids) {
//        return [NSKeyedUnarchiver unarchiveObjectWithData:ids];
//    } else {
//        return nil;
//    }
//}

//-(BOOL)existsInDatabase:(NSString *)itemId {
//    BOOL exists = NO;
//    NSArray *ids = [self getIdsList];
//    if (ids == nil) {
//        return exists;
//    } else {
//        exists = [ids containsObject:itemId];
//    }
//    
//    return exists;
//}

//-(void)updateIdsList:(NSString *)_id {
//    NSMutableArray *ids = [self getIdsList];
//    [ids addObject:_id];
//    NSData *updated = [NSKeyedArchiver archivedDataWithRootObject:ids];
//    [[NSUserDefaults standardUserDefaults] setObject:updated forKey:LIST_OF_ITEMS_IDS];
//}

//-(Item *)getItem:(NSString *)itemId {
//    
//    if ([self existsInDatabase:itemId]) {
//        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:itemId]];
//    } else {
//        return nil;
//    }
//}

//-(void)removeItem:(NSString *)itemName {
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:itemName];
//}

//-(NSArray *)getItems:(int)_offset {
//    NSArray *ids = [self getIdsList];
//    int offset = ([ids count] < _offset) ? [ids count]: _offset;
//    NSArray *idsSubArray = [ids subarrayWithRange:NSMakeRange(0, offset)];
//    NSMutableArray *items = [[NSMutableArray alloc] init];
//    
//    for (id itemId in idsSubArray) {
//        [items addObject:[self getItem:itemId]];
//    }
//    
//    return items;
//}

//-(void)createItemFromJson:(NSDictionary *)json {
//
//    Item *item = [[Item alloc] init];
//    item._id = [[json valueForKey:@"metadata"] valueForKey:@"itemId"];
//    item.name = [json valueForKey:@"name"];
//    item.description = [json valueForKey:@"description"];
//    
//    NSString *imageName = [[json valueForKey:@"imageInfo"] valueForKey:@"name"];
//    NSString *imageUrl = [[json valueForKey:@"imageInfo"] valueForKey:@"url"];
//    item.image = [[ImageInfo alloc] initWithData:imageName :imageUrl];
//    
//    int currencyType = [[[json valueForKey:@"currency"] valueForKey:@"typeOf"] integerValue];
//    double value = [[[json valueForKey:@"currency"] valueForKey:@"value"] doubleValue];
//    NSString *currency = [[json valueForKey:@"currency"] valueForKey:@"virtualCurrency"];
//    item.currency = [[Currency alloc] initWithData:currencyType :value :currency];
//    
//    NSData *_savedData = [NSKeyedArchiver archivedDataWithRootObject:item];
//    [[NSUserDefaults standardUserDefaults] setObject:_savedData forKey:item._id];
//    [self updateIdsList:item._id];
//}

@end
