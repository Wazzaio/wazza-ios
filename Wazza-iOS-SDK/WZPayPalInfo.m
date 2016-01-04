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


#import "WZPayPalInfo.h"

@implementation WZPayPalInfo


-(instancetype)initWithPayPalPayment:(PayPalPayment *)payment :(NSString *)userId :(bool)success {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormat dateFromString:payment.confirmation[@"response"][@"create_time"]];
    
    //TODO session hash
    NSString *itemName = ((PayPalItem *)payment.items[0]).name;
    self = [super initPayment:[self generateID] :itemName :userId :payment.amount.doubleValue :date :1 :@"HASH" :PayPal :success];
    
    if (self) {
        self.currencyCode = payment.currencyCode;
        self.shortDescription = payment.description;
        self.intent = payment.confirmation[@"response"][@"intent"];
        self.processable = payment.processable;
        self.responseID = payment.confirmation[@"response"][@"id"];
        self.state = payment.confirmation[@"response"][@"state"];
        self.responseType = payment.confirmation[@"response_type"];
    }
    
    return self;
}

-(NSDictionary *)toJson {
    NSMutableDictionary *json = (NSMutableDictionary *)[super toJson];
    [json setValue:self.currencyCode forKey:@"currencyCode"];
//    [json setValue:self.shortDescription forKey:@"description"];
    [json setValue:self.intent forKey:@"intent"];
    [json setValue:[NSNumber numberWithBool: self.processable] forKey:@"processable"];
    [json setValue:self.responseID forKey:@"responseID"];
    [json setValue:self.state forKey:@"state"];
    [json setValue:self.responseType forKey:@"responseType"];
    [json setValue:[NSNumber numberWithLong:self.quantity] forKey:@"quantity"];
    return (NSDictionary *)json;
}

@end
