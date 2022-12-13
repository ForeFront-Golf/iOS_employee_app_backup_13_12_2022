//
//  DDMLocationManager.h
//  LocationServicesSuite
//
//  Created by Matt Michels on 10/6/15.
//  Copyright © 2015 DDM App Design, Inc. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "DDMLocationManagerConstants.h"
#import "DDMLocationManagerUtils.h"

@interface DDMLocationManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)manager;
+ (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address;
- (void)updateCurrentLocation;
- (CLLocationCoordinate2D)getCurrentLocationIfUpdated;
- (BOOL)isAlwaysAuthorized;
- (void)requestAlwaysAuthorization;
- (void)updateStateForRegionWithIdentifier:(NSString*)identifier;
- (void)setCircularGeoFence:(double)latitude longitude:(double)longitude radius:(double)radius identifier:(NSString *)identifier;
- (void)setCircularGeoFence:(CLLocationCoordinate2D)center radius:(double)radius identifier:(NSString *)identifier;
- (void)removeGeoFence:(NSString *)identifier;
- (void)removeAllGeoFences;
- (void)setUpdateFrequency:(NSTimeInterval)timeInterval;
- (void)resetUpdateFrequency;


@property (nonatomic) BOOL didLocateUser;
@property (nonatomic) BOOL shouldSendNotification;
@property double horizontalAccuracy;
@property double verticalAccuracy;
@property NSTimer *updateTimer;
@property (nonatomic) NSTimeInterval updateTime;
@property (nonatomic) float distanceFilter;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLCircularRegion *circularRegion;

@end
