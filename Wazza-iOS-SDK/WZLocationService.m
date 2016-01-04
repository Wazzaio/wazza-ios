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


#import "WZLocationService.h"

@interface WZLocationService ()

@property(nonatomic, strong) CLLocationManager *manager;
@property(nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation WZLocationService

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
        self.currentLocation = [[WZLocationInfo alloc] initWithLocationData:[latitude doubleValue] :[longitude doubleValue]];
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
