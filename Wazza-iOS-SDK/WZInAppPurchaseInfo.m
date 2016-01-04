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


#import "WZInAppPurchaseInfo.h"
#import "WZSecurityService.h"

@implementation WZInAppPurchaseInfo

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)generateID {
    WZSecurityService *securityService = [[WZSecurityService alloc] init];
    NSString *idValue = [[NSString alloc] initWithFormat:@"%@-%@-%@", [self itemId], [self dateToString], [self deviceInfo]];
    return [securityService hashContent:idValue];
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary *)toJson {
    NSMutableDictionary *json = (NSMutableDictionary *)[super toJson];
    [json setObject:self.itemId forKey:@"itemId"];
    return json;
    
}

-(instancetype)initFromTransaction:(SKPaymentTransaction *)transaction
                                  : (double)price
                                  :(NSString *)userId {
    //TODO HASH
    self = [super initPayment:[self generateID] :transaction.payment.description :userId :price :transaction.transactionDate :transaction.payment.quantity :@"" :IAP :(transaction.error == nil)];
    if (self) {
        self.itemId = transaction.payment.productIdentifier;
        self.transaction = transaction;
    }
    
    return self;
}

-(instancetype)initForPurchase:(NSString *)userId :(NSString *)itemId :(double)price :(NSInteger)quantity {
    self = [super init];
    
    if (self) {
        self.time = [NSDate date];
        self._id = [self generateID];
        self.deviceInfo = [[WZDeviceInfo alloc] initDeviceInfo];
        self.userId = userId;
        self.itemId = itemId;
        self.price = price;
        self.quantity = quantity;
    }
    
    return self;
}

@end
