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
#import "PayPalMobile.h"
#import "WZPayPalPaymentRequest.h"
#import "WZPaymentSystemsDelegate.h"

@interface WZPayPalService : NSObject

@property (nonatomic, weak) id<WZPaymentSystemsDelegate> delegate;
@property(nonatomic, strong) PayPalPayment *currentPayment;

-(id)initService:(NSString *)token
                :(NSString *)userId
                :(NSString *)productionClientID
                :(NSString *)sandboxClientID
                :(NSString *)APIClientID
                :(NSString *)APISecret
                :(NSString *)merchantName
                :(NSString *)privacyPolicyURL
                :(NSString *)userAgreementURL
                :(BOOL)acceptCreditCards
                :(BOOL)testFlag;

-(void)connect:(UIViewController *)viewController;

//-(void)setEnvironment:(NSString *)environment;

-(BOOL)validateRequestPaymentArguments:(NSString *)name
                                      :(NSUInteger)quantity
                                      :(NSDecimalNumber *)price
                                      :(NSString *)currency
                                      :(NSString *)sku;

-(void)makePayment:(WZPayPalPaymentRequest *)request;

@end