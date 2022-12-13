//
//  DDMLocationManagerConstants.h
//  LocationServicesSuite
//
//  Created by Matt Michels on 10/6/15.
//  Copyright © 2015 DDM App Design, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef DDMLocationManagerConstants_h
#define DDMLocationManagerConstants_h

static NSInteger const kForcedLocationId = INT16_MAX;
static NSString *const kUserLocationUpdated = @"userLocationUpdated";
static NSString *const kUserEnteredRegion = @"userEnteredRegion";
static NSString *const kUserExitedRegion = @"userExitedRegion";
static NSString *const kCurrentLatitude = @"latitude";
static NSString *const kCurrentLongitude = @"longitude";
static NSString *const kCurrentHorizontalAccuracy = @"currentHorizontalAccuracy";
static NSString *const kCurrentVerticalAccuracy = @"currentVerticalAccuracy";

#endif /* DDMLocationManagerConstants_h */
