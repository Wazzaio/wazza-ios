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
#import <StoreKit/StoreKit.h>

typedef enum : NSUInteger {
    IAP,
    Stripe,
    PayPal,
} PaymentSystem;

@interface WZPaymentInfo : NSObject

@property(nonatomic) NSString *_id;
@property NSString *name;
@property(nonatomic) NSString *userId;
@property(nonatomic) double price;
@property(nonatomic) NSDate *time;
@property(nonatomic, strong) WZLocationInfo *location;
@property(nonatomic, strong) WZDeviceInfo *deviceInfo;
@property(nonatomic) NSInteger quantity;
@property(nonatomic) NSString *sessionHash;
@property bool success;
@property NSUInteger paymentSystem;

-(instancetype)initPayment:(NSString *)_id
                          :(NSString *)name
                          :(NSString *)userId
                          :(double)price
                          :(NSDate *)date
                          :(NSInteger)quantity
                          :(NSString *)hash
                          :(NSUInteger)systemType
                          :(bool)success;

-(NSString *)generateID;

-(NSString *)dateToString;

-(NSDictionary *)toJson;


@end