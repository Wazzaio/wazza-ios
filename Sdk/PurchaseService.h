//
//  PurchaseService.h
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "PurchaseDelegate.h"

@interface PurchaseService : NSObject

@property (nonatomic, weak) id<PurchaseDelegate> delegate;
@property (nonatomic, strong) NSString *userId;

-(id)initService:(NSString *)userId;

-(BOOL)canMakePurchase;

-(void)purchaseItem:(NSString *)itemId;

@end
