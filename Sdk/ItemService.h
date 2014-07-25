//
//  ItemService.h
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "ItemDelegate.h"

typedef void (^OnSuccess)(NSArray *);
typedef void (^OnFailure)(NSError *);

@interface ItemService : NSObject

@property (nonatomic) NSString *companyName;
@property (nonatomic) NSString *applicationName;
@property (nonatomic, weak) id<ItemDelegate> delegate;

-(id)initWithAppName:(NSString *)companyName :(NSString *)applicationName;

-(NSArray *)getRecommendedItems:(int)limit
                               :(OnSuccess)success
                               :(OnFailure)failure;

-(void)fetchItems:(int)offset;

-(NSString *)getItemIdFromJson:(NSDictionary *) jsonItem;

-(Item *)getItem:(NSString *)name;

-(NSArray *)getItems:(int)offset;

@end
