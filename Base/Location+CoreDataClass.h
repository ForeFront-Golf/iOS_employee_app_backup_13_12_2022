//
//  Location+CoreDataClass.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-16.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSManagedObject

- (float)distanceToLatitude:(double)latitude andLongitude:(double)longitude;

@end

NS_ASSUME_NONNULL_END

#import "Location+CoreDataProperties.h"
