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


#import <Foundation/Foundation.h>
#import "WZLocationInfo.h"
#import "WZDeviceInfo.h"

@interface WZSessionInfo : NSObject

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *sessionHash;
@property(nonatomic, strong) NSString *token;
@property(nonatomic) NSDate *startTime;
@property(nonatomic) NSDate *endTime;
@property(nonatomic, strong) WZLocationInfo *location;
@property(nonatomic, strong) WZDeviceInfo *device;
@property(nonatomic, strong) NSMutableArray *purchases;

-(id)initSessionInfo:(NSString *)userId;

-(void)addPurchaseId:(NSString *)pId;

-(NSDictionary *)toJson;

-(NSString *)sessionHash;

-(void)updateLocationInfo:(double)latitude :(double)longitude;

-(void)setEndDate;

@end
