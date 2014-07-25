//
//  DeviceInfo.m
//  Sdk
//
//  Created by Joao Vasques on 31/03/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "DeviceInfo.h"
#import <UIKit/UIDevice.h>
#include "TargetConditionals.h"

@implementation DeviceInfo

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
