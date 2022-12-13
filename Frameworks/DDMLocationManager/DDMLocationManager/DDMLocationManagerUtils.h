//
//  DDMLocationManagerUtils.h
//  LocationServicesSuite
//
//  Created by Matt Michels on 10/6/15.
//  Copyright © 2015 DDM App Design, Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface DDMLocationManagerUtils : NSObject

+ (double)getDistanceInMetersBetweenCoordinates:(CLLocationCoordinate2D)coord1 coord2:(CLLocationCoordinate2D) coord2;
+ (CLLocationCoordinate2D)geoCodeUsingAddress:(NSString *)address;

@end
