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


#import "WZCurrency.h"

@implementation WZCurrency

-(id)initWithData:(int)type :(double)value :(NSString *)currency {
    self = [super init];
    self.type = type;
    self.value = value;
    self.currency = currency;
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type = [decoder decodeIntForKey:@"type"];
    self.value = [decoder decodeDoubleForKey:@"value"];
    self.currency = [decoder decodeObjectForKey:@"currency"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeDouble:self.value forKey:@"value"];
    [encoder encodeObject:self.currency forKey:@"currency"];
}

@end
