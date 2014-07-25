//
//  LocationService.m
//  Sdk
//
//  Created by Joao Luis Vazao Vasques on 25/07/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import "LocationService.h"

@interface LocationService ()

@property(nonatomic, strong) CLLocationManager *manager;
@property(nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation LocationService

-(id)initService {
    self = [super init];
    
    if (self) {
        if ([self isLocationServiceAvailable]) {
            self.manager = [[CLLocationManager alloc] init];
            self.manager.delegate = self;
            self.manager.desiredAccuracy = kCLLocationAccuracyBest;
            [self.manager startUpdatingLocation];
        }
    }
    
    return self;
}

#pragma mark LocationManager

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Cannot get location: %@", error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocation *loc = newLocation;
    
    if (loc != nil) {
        NSNumber *latitude = [[NSNumber alloc] initWithDouble:loc.coordinate.latitude];
        NSNumber *longitude = [[NSNumber alloc] initWithDouble:loc.coordinate.longitude];
        self.currentLocation = [[LocationInfo alloc] initWithLocationData:[latitude doubleValue] :[longitude doubleValue]];
    }
    
}

-(BOOL)isLocationServiceAvailable
{
    if([CLLocationManager locationServicesEnabled]==NO ||
       [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted){
        return NO;
    }else{
        return YES;
    }
}

@end
