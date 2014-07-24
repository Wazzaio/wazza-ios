//
//  SDK.h
//  SDK
//
//  Created by Joao Vasques on 18/02/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "PurchaseInfo.h"
#import "WazzaSDKDelegate.h"

@interface SDK : NSObject

@property (nonatomic, weak) id<WazzaSDKDelegate> delegate;

-(id)initWithCredentials:(NSString *)companyName
                        :(NSString *)applicationName
                        :(NSString *)secretKey;

#pragma Session functions

-(void)newSession;

// -(void)resumeSession;

-(void)endSession;

#pragma Items and purchases

//-(void)getRecommendedItems:(int)limit;

//-(Item *)getItem:(NSString *)name;
//
//-(NSArray *)getItems:(int)limit;

-(void)makePurchase:(Item *)item;

#pragma Other stuff

-(void)allowGeoLocation;

@end
