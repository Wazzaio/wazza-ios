//
//  SessionInfo.m
//  Sdk
//
//  Created by Joao Vasques on 28/03/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <UIKit/UIDevice.h>
#import "SessionInfo.h"
#import "DeviceInfo.h"
#import "SecurityService.h"

@interface SessionInfo ()

@property(nonatomic, strong) SecurityService *securityService;

@end

@implementation SessionInfo

-(id)initSessionInfo:(NSString *)appName
                    :(NSString *)companyName {
    self = [super init];
    
    if (self) {
        self.userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.applicationName = appName;
        self.companyName = companyName;
        self.startTime = [NSDate date];
        self.endTime = [NSDate date];
        self.location = nil;
        self.device = [[DeviceInfo alloc] initDeviceInfo];
        self.securityService = [[SecurityService alloc] init];
        self.purchases = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)addPurchaseId:(NSString *)pId {
    [self.purchases addObject:pId];
}

-(void)updateLocationInfo:(double)latitude :(double)longitude {
    self.location = [[LocationInfo alloc] initWithLocationData:latitude :longitude];
}

-(NSString *)sessionHash {
    NSDictionary *json = self.toJson;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:0
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [self.securityService hashContent:jsonString];
    }
}

-(NSDictionary *)toJson {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setObject:self.userId forKey:@"userId"];
    [json setObject:self.applicationName forKey:@"applicationName"];
    [json setObject:self.companyName forKey:@"companyName"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [json setObject:[dateFormatter stringFromDate:self.startTime] forKey:@"startTime"];
    [json setObject:[dateFormatter stringFromDate:self.endTime] forKey:@"endTime"];
    
    if (self.location != nil) {
        [json setObject:[[NSNumber alloc] initWithDouble:self.location.latitude] forKey:@"latitude"];
        [json setObject:[[NSNumber alloc] initWithDouble:self.location.longitude] forKey:@"longitude"];
    }
    
    if (self.device != nil) {
        [json setObject:[self.device toJson] forKey:@"deviceInfo"];
    }
    
    ([self.purchases count] > 0) ? [json setObject:self.purchases forKey:@"purchases"] : [json setObject:@[] forKey:@"purchases"];
    
    return json;
}

-(void)setEndDate {
    self.endTime = [NSDate date];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.userId = [decoder decodeObjectForKey:@"userId"];
    self.sessionHash = [decoder decodeObjectForKey:@"sessionHash"];
    self.applicationName = [decoder decodeObjectForKey:@"applicationName"];
    self.companyName = [decoder decodeObjectForKey:@"companyName"];
    self.startTime = [decoder decodeObjectForKey:@"startTime"];
    self.endTime = [decoder decodeObjectForKey:@"endTime"];
    self.device = [decoder decodeObjectForKey:@"device"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:[self sessionHash] forKey:@"sessionHash"];
    [encoder encodeObject:self.applicationName forKey:@"applicationName"];
    [encoder encodeObject:self.companyName forKey:@"companyName"];
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeObject:self.endTime forKey:@"endTime"];
    [encoder encodeObject:self.device forKey:@"device"];
}

@end
