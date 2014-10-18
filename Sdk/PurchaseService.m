//
//  PurchaseService.m
//  Sdk
//
//  Created by Joao Vasques on 02/04/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "PurchaseService.h"
#import <StoreKit/StoreKit.h>
#import "WazzaError.h"
#import "PurchaseInfo.h"
#import "PersistenceService.h"

@interface PurchaseService() <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property(nonatomic, strong) SKProductsRequest *productRequest;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) PersistenceService *persistenceService;

@end

@implementation PurchaseService

@synthesize delegate;

-(id)initWithAppName:(NSString *)companyName :(NSString *)appName :(NSString *)userId {
    self = [super init];
    if (self) {
        self.companyName = companyName;
        self.appName = appName;
        self.userId = userId;
        self.items = [[NSMutableArray alloc] init];
        self.persistenceService = [[PersistenceService alloc] initPersistence];
    }
    return self;
}

-(BOOL)canMakePurchase {
    return [SKPaymentQueue canMakePayments];
}

-(void)purchaseItem:(NSString *)item {

    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:item, nil]];
        productRequest.delegate = self;
        [productRequest start];
    } else {
        NSString *errorMsg = [[NSString alloc] initWithFormat:@"%@",@"Purchases disabled"];
        WazzaError *error = [[WazzaError alloc] initWithMessage:errorMsg];
        [self.delegate onPurchaseFailure:error];
    }
}

-(void)executePaymentRequest:(SKProduct *)item {
    NSLog(@"ITEM DETAILS %@ | %@", item.localizedTitle, item.price);
    SKPayment *payment = [SKPayment paymentWithProduct:item];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma Products Request Delegate

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *products = response.products;
    NSArray *invalid = response.invalidProductIdentifiers;
    
    if (invalid.count > 0) {
        NSString *errorMsg = [[NSString alloc] initWithFormat:@"%@",@"request item is invalid"];
        WazzaError *error = [[WazzaError alloc] initWithMessage:errorMsg];
        [self.delegate onPurchaseFailure:error];
        return;
    }
    
    if (products.count > 0) {
        [self executePaymentRequest:products[0]];
        return;
    } else {
        NSString *errorMsg = [[NSString alloc] initWithFormat:@"%@",@"No product found"];
        WazzaError *error = [[WazzaError alloc] initWithMessage:errorMsg];
        [self.delegate onPurchaseFailure:error];
        return;
    }
}

#pragma mark StoreKit Delegate

-(void)handleTransactionSuccess:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue ] finishTransaction:transaction];
    
    double price = 0;
    for (SKProduct *item in self.items) {
        if (item.productIdentifier == transaction.payment.productIdentifier) {
            price = [item.price doubleValue];
            break;
        }
    }
    
    [self.delegate onPurchaseSuccess:
     [[PurchaseInfo alloc] initFromTransaction:transaction :self.appName :price :self.userId]
    ];
}

-(void)paymentQueue:(SKPaymentQueue *)queue
    updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Transaction of item %@ being purchased", transaction.payment.productIdentifier);
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"ERROR %@", transaction.error);
                [self.delegate onPurchaseFailure:[[WazzaError alloc] initWithMessage:transaction.error.localizedDescription]];
                break;
            case SKPaymentTransactionStatePurchased:
                [self handleTransactionSuccess:transaction];
                break;
            default:
                break;
        }
    }
    
}

@end
