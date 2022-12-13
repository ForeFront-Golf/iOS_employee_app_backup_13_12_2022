//
//  DDMLocationManager.m
//  LocationServicesSuite
//
//  Created by Matt Michels on 10/6/15.
//  Copyright © 2015 DDM App Design, Inc. All rights reserved.
//

#import "DDMLocationManagerConstants.h"
#import "DDMLocationManager.h"
#import <UIKit/UIKit.h>

@interface DDMLocationManager ()
@property (nonatomic, strong) CLLocation *bestLocation;
@property (nonatomic) BOOL timerEnabled;
@end

@implementation DDMLocationManager

@synthesize location, locationManager, didLocateUser, shouldSendNotification, updateTimer;

+ (instancetype)manager {
    static DDMLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

+ (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

- (id)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = self.distanceFilter;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        self.locationManager.allowsBackgroundLocationUpdates = YES;
        [self.locationManager requestAlwaysAuthorization];
        self.updateTimer = nil;
        self.timerEnabled = NO;
        [self.locationManager startUpdatingLocation];
//        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    return self;
}

- (void)disableLocationManager {
    [self.locationManager stopUpdatingLocation];
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    self.timerEnabled = NO;
}

- (void)setDistanceFilter:(float)distanceFilter {
    _distanceFilter = distanceFilter;
    self.locationManager.distanceFilter = self.distanceFilter;
}

- (CLLocationCoordinate2D)getCurrentLocationIfUpdated {
    if (!didLocateUser) {
        [self updateCurrentLocation];
    }
    return CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Failed to get location: %@", error.userInfo);
    
    if([CLLocationManager locationServicesEnabled]){
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"App Permission Denied"
//                                                                           message:@"To re-enable, please go to Settings and turn on Location Service for this app."
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
            NSLog(@"Error: Location services not enabled.");
        }
    }
}

- (void)updateCurrentLocation
{
    if (self.timerEnabled && self.bestLocation != nil)
    {
        [self broadcastUpdatedLocationNotification];
    }
    
    didLocateUser = NO;
    self.bestLocation = nil;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

- (void)requestAlwaysAuthorization {
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
}

- (BOOL)isAlwaysAuthorized {
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ? YES : NO;
    }
    else {
        if ([CLLocationManager locationServicesEnabled]) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

- (void)updateStateForRegionWithIdentifier:(NSString*)identifier;
{
    if(_bestLocation)
    {
        CLCircularRegion *region = [[locationManager.monitoredRegions filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@",identifier]] allObjects].firstObject;
        if([region containsCoordinate:_bestLocation.coordinate])
        {
            [self locationManager:locationManager didEnterRegion:region];
        }
        else
        {
            if(!region)
            {
                region = [NSNull null];
            }
            [self locationManager:locationManager didExitRegion:region];
        }
    }
}

- (void)setCircularGeoFence:(double)latitude longitude:(double)longitude radius:(double)radius identifier:(NSString *)identifier
{
   [self setCircularGeoFence:CLLocationCoordinate2DMake(latitude, longitude) radius:radius identifier:identifier];
}

- (void)setCircularGeoFence:(CLLocationCoordinate2D)center radius:(double)radius identifier:(NSString *)identifier
{
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
    [locationManager startMonitoringForRegion:region];
}

- (void)removeGeoFence:(NSString *)identifier {
    NSSet *fences = [self.locationManager monitoredRegions];
    if (fences != nil) {
        [fences enumerateObjectsUsingBlock:^(CLCircularRegion *region, BOOL * _Nonnull stop) {
            if ([[region identifier] isEqualToString:identifier]) {
                [self.locationManager stopMonitoringForRegion:region];
            }
        }];
    }
}

- (void)removeAllGeoFences {
    NSSet *fences = [self.locationManager monitoredRegions];
    if (fences != nil) {
        [fences enumerateObjectsUsingBlock:^(CLCircularRegion *region, BOOL * _Nonnull stop) {
            [self.locationManager stopMonitoringForRegion:region];
        }];
    }
}

- (void)setUpdateFrequency:(NSTimeInterval)timeInterval
{
    [self resetUpdateFrequency];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                        target:self
                                                      selector:@selector(updateCurrentLocation)
                                                      userInfo:nil
                                                       repeats:YES];
    self.timerEnabled = YES;
}

- (void)resetUpdateFrequency {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    self.timerEnabled = NO;
}

- (double)getDistanceForDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy {
    if (desiredAccuracy == kCLLocationAccuracyBestForNavigation) {
        return -1.0;
    }
    else if (desiredAccuracy == kCLLocationAccuracyNearestTenMeters) {
        return 10.0;
    }
    else if (desiredAccuracy == kCLLocationAccuracyBest) {
        return 65.0;
    }
    else if (desiredAccuracy == kCLLocationAccuracyHundredMeters) {
        return 100.0;
    }
    else if (desiredAccuracy == kCLLocationAccuracyKilometer) {
        return 1000.0;
    }
    else if (desiredAccuracy == kCLLocationAccuracyThreeKilometers) {
        return 3000.0;
    }
    else {
        return 0.0;
    }
}

- (void)broadcastUpdatedLocationNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLocationUpdated
                                                        object:nil
                                                      userInfo:@{
                                                                 kCurrentLatitude:[NSNumber numberWithDouble:self.bestLocation.coordinate.latitude],
                                                                 kCurrentLongitude:[NSNumber numberWithDouble:self.bestLocation.coordinate.longitude],
                                                                 kCurrentHorizontalAccuracy:[NSNumber numberWithDouble:self.horizontalAccuracy],
                                                                 kCurrentVerticalAccuracy:[NSNumber numberWithDouble:self.verticalAccuracy]
                                                                 }];
}

#pragma CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
//    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
//    if (locationAge > 5.0) {
//        return;
//    }
    
    // test that the horizontal accuracy does not indicate an invalid measurement and is not a forced location change
    if (newLocation.horizontalAccuracy < 0)
    {
        return;
    }
    
//    CLLocationAccuracy bestHorAccuracy = self.bestLocation.horizontalAccuracy;
//    CLLocationAccuracy newHorAccuracy = newLocation.horizontalAccuracy;
    
//    if (self.bestLocation == nil || self.bestLocation.horizontalAccuracy > newLocation.horizontalAccuracy || newLocation.horizontalAccuracy == kForcedLocationId)
    {
        self.bestLocation = newLocation;
        self.horizontalAccuracy = self.locationManager.location.horizontalAccuracy;
        self.verticalAccuracy = self.locationManager.location.verticalAccuracy;
        
        NSLog(@"Location Horizontal Accuracy: %f, Location Vertical Accuracy: %f",
              self.locationManager.location.horizontalAccuracy,
              self.locationManager.location.verticalAccuracy);
        
        if (newLocation.horizontalAccuracy <= [self getDistanceForDesiredAccuracy:self.locationManager.desiredAccuracy] && !self.timerEnabled) {
            NSLog(@"Desired accuracy reached, no timer enabled, calling cancelPreviousPerformRequestsWithTarget");
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disableLocationManager) object:nil];
        }
        
        [self broadcastUpdatedLocationNotification];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserEnteredRegion object:nil userInfo:@{@"region":region}];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserExitedRegion object:nil userInfo:@{@"region":region}];
}

@end
