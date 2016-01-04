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


#import <StoreKit/StoreKit.h>
#import "WZPaymentInfo.h"
#import "WZLocationInfo.h"
#import "WZSecurityService.h"
#import "WZDeviceInfo.h"

@implementation WZPaymentInfo

-(instancetype)initPayment:(NSString *)_id
                          :(NSString *)name
                          :(NSString *)userId
                          :(double)price
                          :(NSDate *)date
                          :(NSInteger)quantity
                          :(NSString *)hash
                          :(NSUInteger)systemType
                          :(bool)success {
    self = [super init];
    if (self) {
        self._id = _id;
        self.name = name;
        self.userId = userId;
        self.price = price;
        self.time = date;
        self.deviceInfo = [[WZDeviceInfo alloc] initDeviceInfo];
        self.location = nil; //TODO
        self.quantity = quantity;
        self.sessionHash = hash;
        self.paymentSystem = systemType;
        self.success = success;
    }
    return self;
}

/**
 Purchase Id format: Hash(itemID + time + device)
 **/
-(NSString *)generateID {
    WZSecurityService *securityService = [[WZSecurityService alloc] init];
    NSString *idValue = [[NSString alloc] initWithFormat:@"%@-%@", [self dateToString], [self deviceInfo]];
    return [securityService hashContent:idValue];
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)dateToString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    return[formatter stringFromDate:self.time];
}

-(NSDictionary *)toJson {
    
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    NSString *time = [self dateToString];
    
    [json setObject:[NSNumber numberWithInteger:self.paymentSystem] forKey:@"paymentSystem"];
    [json setObject:self._id forKey:@"id"];
    [json setObject:self.name forKey:@"itemId"];
    [json setObject:self.userId forKey:@"userId"];
    [json setObject:[[NSNumber alloc] initWithDouble:self.price] forKey:@"price"];
    [json setObject:time forKey:@"time"];
    [json setObject:[self.deviceInfo toJson] forKey:@"deviceInfo"];
    [json setObject:self.sessionHash forKey:@"sessionId"];
    [json setValue:[NSNumber numberWithBool: self.success] forKey:@"success"];
    
    return json;
}

@end