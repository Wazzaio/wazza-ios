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
#import <PayPalMobile.h>
#import "WZPaymentInfo.h"

@interface WZPayPalInfo : WZPaymentInfo

@property NSString *currencyCode;
@property NSString *shortDescription;
@property NSString *intent;
@property BOOL processable;

/**
 *  Response
 */
@property NSString *responseID;
@property NSString *state;
@property NSString *responseType;

/**
 *  <#Description#>
 *
 *  @param payment <#payment description#>
 *  @param userId  <#userId description#>
 *  @param success <#success description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithPayPalPayment:(PayPalPayment *)payment :(NSString *)userId :(bool)success;

@end


/**
 PayPal result example:
 2015-03-18 16:16:59.224 demo[1231:26934] PayPal Payment Success!
 2015-03-18 16:16:59.225 demo[1231:26934]
 CurrencyCode: USD
 Amount: 2.00
 Short Description: description
 Intent: sale
 Processable: Already processed
 Display: $2.00
 Confirmation: {
 client =     {
 environment = mock;
 "paypal_sdk_version" = "2.9.0";
 platform = iOS;
 "product_name" = "PayPal iOS SDK";
 };
 response =     {
 "create_time" = "2015-03-18T16:14:48Z";
 id = "PAY-NONETWORKPAYIDEXAMPLE123";
 intent = sale;
 state = approved;
 };
 "response_type" = payment;
 }
 Details: (null)
 Shipping Address: (null)
 Invoice Number: (null)
 Custom: (null)
 Soft Descriptor: (null)
 BN code: (null)

**/