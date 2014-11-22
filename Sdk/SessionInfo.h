//
//  SessionInfo.h
//  Sdk
//
//  Created by Joao Vasques on 28/03/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationInfo.h"
#import "DeviceInfo.h"

@interface SessionInfo : NSObject

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *sessionHash;
@property(nonatomic, strong) NSString *token;
@property(nonatomic) NSDate *startTime;
@property(nonatomic) NSDate *endTime;
@property(nonatomic, strong) LocationInfo *location;
@property(nonatomic, strong) DeviceInfo *device;
@property(nonatomic, strong) NSMutableArray *purchases;

-(id)initSessionInfo:(NSString *)userId;

-(void)addPurchaseId:(NSString *)pId;

-(NSDictionary *)toJson;

-(NSString *)sessionHash;

-(void)updateLocationInfo:(double)latitude :(double)longitude;

-(void)setEndDate;

@end
