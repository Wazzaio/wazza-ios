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


#import "WZDeviceInfo.h"

#import "WZDeviceInfo.h"
#import <UIKit/UIDevice.h>
#include "TargetConditionals.h"

@implementation WZDeviceInfo

-(id)initDeviceInfo {
    
    self = [super init];
    if (self) {
#if TARGET_IPHONE_SIMULATOR
        self.osName = @"iOs-Simulator-OS";
        self.osVersion = @"SimulatorVersion";
        self.deviceModel = @"SimulatorModel";
#else
        self.osName = [[UIDevice currentDevice] systemName];
        self.osVersion = [[UIDevice currentDevice] systemVersion];
        self.deviceModel = [[UIDevice currentDevice] model];
#endif
    }
    
    return self;
}

-(id)initWithData:(NSString *)name :(NSString *)version :(NSString *)model {
    self = [super init];
    
    if (self) {
        self.osName = name;
        self.osVersion = version;
        self.deviceModel = model;
    }
    
    return self;
}

-(NSDictionary *)toJson {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setObject:self.osName forKey:@"osName"];
    [json setObject:self.osVersion forKey:@"osVersion"];
    [json setObject:self.deviceModel forKey:@"deviceModel"];
    [json setObject:@"iOS" forKey:@"osType"];
    return json;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.osName = [decoder decodeObjectForKey:@"osName"];
    self.osVersion = [decoder decodeObjectForKey:@"osVersion"];
    self.deviceModel = [decoder decodeObjectForKey:@"model"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.osName forKey:@"osName"];
    [encoder encodeObject:self.osVersion forKey:@"osVersion"];
    [encoder encodeObject:self.deviceModel forKey:@"model"];
}

@end