//
//  Location+CoreDataClass.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-16.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Location+CoreDataClass.h"
#import "User+CoreDataClass.h"

@implementation Location

- (void)setLat:(NSNumber *)lat
{
    [self willChangeValueForKey:@"lat"];
    [self setPrimitiveValue:lat forKey:@"lat"];
    [self didChangeValueForKey:@"lat"];
    
    [self.user makeDirty];
    [self.user.orders makeObjectsPerformSelector:@selector(makeDirty)];
}

- (float)distanceToLatitude:(double)latitude andLongitude:(double)longitude
{
    CLLocation* location1 = [[CLLocation alloc] initWithLatitude:self.lat.doubleValue longitude:self.lon.doubleValue];
    CLLocation* location2 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    double distance = [location1 distanceFromLocation:location2];
    return distance;
}

@end
