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


#import "WZPayPalService.h"
#import "PayPalMobile.h"
#import <QuartzCore/QuartzCore.h>
#import "WZPayPalInfo.h"
#import "UtilsService.h"
#import "WZNetworkService.h"
#import "WZSecurityService.h"

#define MAX_PAY_PAL_ITEM_NAME 127
#define MAX_PAY_PAL_ITEM_QUANTITY 10
#define MAX_PAY_PAL_ITEM_PRICE 10

#define VERIFY_PAYMENT_URL @"payment/verify"

@interface WZPayPalService () <PayPalPaymentDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong) UIViewController *parentController;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(atomic, strong) NSString *apiClientID;
@property(atomic, strong) NSString *apiSecret;
@property(strong) NSString *userId;
@property(strong) WZNetworkService *networkService;
@property(strong) NSString *sdkToken;

@end

@implementation WZPayPalService

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
                :(BOOL)testFlag {
    self = [super init];
    if (self) {
        self.networkService = [[WZNetworkService alloc] initService];
        self.sdkToken = token;
        self.userId = userId;
        self.apiClientID = APIClientID;
        self.apiSecret = APISecret;
        NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
        if (productionClientID != nil) {
            [args setObject:productionClientID forKey:PayPalEnvironmentProduction];
        }
        if (sandboxClientID != nil) {
            [args setObject:sandboxClientID forKey:PayPalEnvironmentSandbox];
        }
        
        if ([args count] == 0) {
            NSLog(@"Cannot initiate PayPal service: both IDs are nil");
            return nil;
        } else {
            [PayPalMobile initializeWithClientIdsForEnvironments:args];
            _payPalConfig = [[PayPalConfiguration alloc] init];
            _payPalConfig.acceptCreditCards = YES;
            _payPalConfig.merchantName = merchantName;
            _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:privacyPolicyURL];
            _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:userAgreementURL];
            
//            testFlag ? (self.environment = PayPalEnvironmentNoNetwork) : (self.environment = PayPalEnvironmentProduction);
            self.environment = PayPalEnvironmentNoNetwork;
            
            // Setting the languageOrLocale property is optional.
            //
            // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
            // its user interface according to the device's current language setting.
            //
            // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
            // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
            // to use that language/locale.
            //
            // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
            
            _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
            
            
            // Setting the payPalShippingAddressOption property is optional.
            //
            // See PayPalConfiguration.h for details.
            
//            _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        }
    }
    return self;
}

-(void)connect:(UIViewController *)viewController {
    // Preconnect to PayPal early
    self.parentController = viewController;
    [PayPalMobile preconnectWithEnvironment:self.environment];
}

//-(void)setEnvironment:(NSString *)environment {
//    self.environment = environment;
//    [self connect:self.parentController];
//}

-(BOOL)validateRequestPaymentArguments:(NSString *)name
                                      :(NSUInteger)quantity
                                      :(NSDecimalNumber *)price
                                      :(NSString *)currency
                                      :(NSString *)sku {
    return
    // name check
    (name != NULL ? [name length] <= MAX_PAY_PAL_ITEM_NAME : false) &&
    // quantity check
    (quantity > 0 && [[NSString stringWithFormat:@"%lu", (unsigned long)quantity] length] <= MAX_PAY_PAL_ITEM_QUANTITY) &&
    // price check
    ([[NSString stringWithFormat:@"%f", [price doubleValue]] length] <= MAX_PAY_PAL_ITEM_PRICE)
    
    //sku check
    ;
}

-(PayPalPayment *)generatePayment:(NSString *)itemName
                                 :(NSString *)description
                                 :(NSString *)sku
                                 :(int)quantity
                                 :(double)price
                                 :(NSString *)currency
                                 :(double)taxCost
                                 :(double)shippingCost {
    
    NSDecimalNumber * _price = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", price]];
    PayPalItem *item = [PayPalItem itemWithName:itemName
                                   withQuantity:quantity
                                      withPrice:_price
                                   withCurrency:currency
                                        withSku:sku];
    NSArray *items = @[item];//, item2, item3];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];

    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = subtotal;
    payment.currencyCode = currency;
    payment.shortDescription = description;
    payment.items = items;
    self.currentPayment = payment;
    return payment;
}

-(void)makePayment:(WZPayPalPaymentRequest *)request {
    NSDecimalNumber * _price = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", request.price]];
    BOOL validateInput = [self validateRequestPaymentArguments:request.itemName :request.quantity :_price :request.currency :request.sku];
    
    if (validateInput) {
        PayPalPayment *payment = [self generatePayment:request.itemName
                                                      :request.shortDescription
                                                      :request.sku
                                                      :request.quantity
                                                      :request.price
                                                      :request.currency
                                                      :request.taxCost
                                                      :request.shippingCost];
        
        // Optional: include payment details
        //  NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
        //  NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
        //  PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
        //                                                                             withShipping:shipping
        //                                                                                  withTax:tax];
        //
        //  NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
        self.payPalConfig.acceptCreditCards = true;
        if (payment.processable) {
            PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                        configuration:_payPalConfig
                                                                                                             delegate:self];
//            paymentViewController.title = request.itemName;
            [self.parentController presentViewController:paymentViewController animated:YES completion:nil];
        } else {
            //TODO not processable: send error message
        }
    } else {
        //TODO send error message
    }
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    NSLog(@"%@", completedPayment);
//    completedPayment.processable
    //TODO check if the payment was already processable or not
    bool success = true;
    WZPayPalInfo *info = [[WZPayPalInfo alloc] initWithPayPalPayment:completedPayment :self.userId :success];
    [self validatePayment:info :paymentViewController];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    PayPalPayment *failedPayment = self.currentPayment;
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

#pragma Validation methods

-(void)validatePayment:(WZPayPalInfo *)paymentInfo :(PayPalPaymentViewController *)paymentViewController {
    NSMutableDictionary *content = (NSMutableDictionary *)[paymentInfo toJson];
    [content setObject:self.apiClientID forKey:@"apiClientId"];
    [content setObject:self.apiSecret forKey:@"apiSecret"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@/", URL, VERIFY_PAYMENT_URL];
    NSDictionary *headers = [WZSecurityService addSecurityInformation:self.sdkToken];
    [self.networkService sendData:requestUrl:
                          headers:
                          content:
     ^(NSArray *result){
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
         NSLog(@"RESULT OK");
         [self.delegate paymentSuccess:paymentInfo];
     }:
     ^(NSError *error){
         NSLog(@"%@", error);
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
        [self.delegate paymentFailure:error];
     }
     ];
}

@end