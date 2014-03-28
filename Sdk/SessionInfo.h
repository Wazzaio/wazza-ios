//
//  SessionInfo.h
//  WazzaSDK
//
//  Created by Joao Vasques on 28/03/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationInfo.h"

@interface SessionInfo : NSObject

@property(nonatomic, strong) NSString *userId;
@property(nonatomic) NSDate *startTime;
@property(nonatomic) double sessionLenght;
@property(nonatomic, strong) LocationInfo *location;

-(id)initWithLocation:(NSString *)userId :(NSDate *)start :(LocationInfo *)location;
-(id)initWithoutLocation: (NSString *)userId :(NSDate *)start;

@end
