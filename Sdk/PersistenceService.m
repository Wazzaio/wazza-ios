//
//  PersistenceService.m
//  Sdk
//
//  Created by Joao Vasques on 28/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "PersistenceService.h"
#import "Item.h"

#define LIST_OF_ITEMS_IDS @"ids"

@implementation PersistenceService

-(id)initPersistence {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSData *ids = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
    [[NSUserDefaults standardUserDefaults] setObject:ids forKey:LIST_OF_ITEMS_IDS];
    return self;
}

-(NSMutableArray *)getIdsList {
    NSData *ids = [[NSUserDefaults standardUserDefaults] objectForKey:LIST_OF_ITEMS_IDS];
    if (ids) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:ids];
    } else {
        return nil;
    }
}

-(BOOL)existsInDatabase:(NSString *)name {
    BOOL exists = NO;
    NSArray *ids = [self getIdsList];
    if (ids == nil) {
        return exists;
    } else {
        exists = [ids containsObject:name];
    }
    
    return exists;
}

-(void)updateIdsList:(NSString *)_id {
    NSMutableArray *ids = [self getIdsList];
    [ids addObject:_id];
    NSData *updated = [NSKeyedArchiver archivedDataWithRootObject:ids];
    [[NSUserDefaults standardUserDefaults] setObject:updated forKey:LIST_OF_ITEMS_IDS];
}

-(Item *)getItem:(NSString *)name {
    
    if ([self existsInDatabase:name]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:name]];
    } else {
        return nil;
    }
}

-(NSArray *)getItems:(int)_offset {
    NSArray *ids = [self getIdsList];
    unsigned long offset = ([ids count] < _offset) ? [ids count]: _offset;
    NSArray *idsSubArray = [ids subarrayWithRange:NSMakeRange(0, offset)];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (id itemName in idsSubArray) {
        [items addObject:[self getItem:itemName]];
    }
    
    return items;
}

-(void)createItemFromJson:(NSDictionary *)json {

    Item *item = [[Item alloc] init];
    item._id = [[json valueForKey:@"metadata"] valueForKey:@"itemId"];
    item.name = [json valueForKey:@"name"];
    item.description = [json valueForKey:@"description"];
    
    NSString *imageName = [[json valueForKey:@"imageInfo"] valueForKey:@"name"];
    NSString *imageUrl = [[json valueForKey:@"imageInfo"] valueForKey:@"url"];
    item.image = [[ImageInfo alloc] initWithData:imageName :imageUrl];
    
    int currencyType = [[[json valueForKey:@"currency"] valueForKey:@"typeOf"] integerValue];
    double value = [[[json valueForKey:@"currency"] valueForKey:@"value"] doubleValue];
    NSString *currency = [[json valueForKey:@"currency"] valueForKey:@"virtualCurrency"];
    item.currency = [[Currency alloc] initWithData:currencyType :value :currency];
    
    NSData *_savedData = [NSKeyedArchiver archivedDataWithRootObject:item];
    [[NSUserDefaults standardUserDefaults] setObject:_savedData forKey:item.name];
    [self updateIdsList:item.name];
}

@end
