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
#import "WZPaymentRequest.h"

@interface WZPayPalPaymentRequest : WZPaymentRequest

@property NSString *itemName;
@property(strong) NSString *shortDescription;
@property NSString *sku;
@property int quantity;
@property double price;
@property NSString *currency;
@property double taxCost;
@property double shippingCost;

-(instancetype)initPaymentRequest:(NSString *)itemName
                         :(NSString *)description
                         :(NSString *)sku
                         :(int)quantity
                         :(double)price
                         :(NSString *)currency
                         :(double)taxCost
                         :(double)shippingCost;

@end
