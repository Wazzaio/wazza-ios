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
#import <StoreKit/StoreKit.h>
#import "WZPaymentInfo.h"

@interface WZInAppPurchaseInfo : WZPaymentInfo

@property(nonatomic) NSString *itemId;
@property(nonatomic, strong) SKPaymentTransaction *transaction;

/**
 *  <#Description#>
 *
 *  @param transaction <#transaction description#>
 *  @param price       <#price description#>
 *  @param userId      <#userId description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initFromTransaction:(SKPaymentTransaction *)transaction
                                  :(double)price
                                  :(NSString *)userId;



/**
 *  Builds a model for a specific In-App Purchase
 *
 *  @param userId   id of buyer
 *  @param itemId   SKU of the item to be bought
 *  @param price    Item's price
 *  @param quantity Number of items to buy
 *
 *  @return IAP model for purchase
 */
-(instancetype)initForPurchase:(NSString *)userId :(NSString *)itemId :(double)price :(NSInteger)quantity;

@end
