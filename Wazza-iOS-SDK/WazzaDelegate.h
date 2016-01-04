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
#import "WZPaymentInfo.h"

/**
 *  Wazza purchase protocol.
 */
@protocol WazzaDelegate <NSObject>

/**
 *  Protocol method that's called if a purchase request is successful.
 *  After finishing all the actions related to the transaction:
 *      - Persist the purchase
 *      - Download associated content (if applicable)
 *      - Update your app's UI
 *  You must call the following function to finish the transaction on Apple's StoreKit
 *          [[SKPaymentQueue defaultQueue ] finishTransaction:info.transaction];
 */
@required
-(void)purchaseSuccess:(WZPaymentInfo *)info;

/**
 *  Protocol method that's called if there was a problem with a purchase request
 */
@required
-(void)PurchaseFailure:(NSError *)error;

@end
