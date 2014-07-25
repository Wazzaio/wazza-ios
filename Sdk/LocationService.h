//
//  LocationService.h
//  Sdk
//
//  Created by Joao Luis Vazao Vasques on 25/07/14.
//  Copyright (c) 2014 Wazza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationInfo.h"

@interface LocationService : NSObject <CLLocationManagerDelegate>

@property(nonatomic, strong) LocationInfo *currentLocation;

-(id)initService;

@end
