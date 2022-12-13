//
//  Location+CoreDataProperties.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-19.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Location+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSNumber *lat;
@property (nullable, nonatomic, copy) NSNumber *location_id;
@property (nullable, nonatomic, copy) NSNumber *lon;
@property (nullable, nonatomic, copy) NSNumber *user_id;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
