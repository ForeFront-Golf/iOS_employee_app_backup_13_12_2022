//
//  DDMLocationManagerUtils.m
//  LocationServicesSuite
//
//  Created by Matt Michels on 10/6/15.
//  Copyright © 2015 DDM App Design, Inc. All rights reserved.
//

#import "DDMLocationManagerUtils.h"

@implementation DDMLocationManagerUtils

+ (double)getDistanceInMetersBetweenCoordinates:(CLLocationCoordinate2D)coord1 coord2:(CLLocationCoordinate2D) coord2
{
    CLLocation* location1 = [[CLLocation alloc] initWithLatitude: coord1.latitude longitude: coord1.longitude];
    CLLocation* location2 = [[CLLocation alloc] initWithLatitude: coord2.latitude longitude: coord2.longitude];
    
    return [location1 distanceFromLocation:location2];
}

+ (CLLocationCoordinate2D)geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@&region=CA", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (((NSArray *)[json objectForKey:@"results"]).count > 0) {
        NSDictionary *tmp = [[[json objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"];
        latitude = [[[tmp objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
        longitude = [[[tmp objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
    }

    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    
    return center;
}


@end
