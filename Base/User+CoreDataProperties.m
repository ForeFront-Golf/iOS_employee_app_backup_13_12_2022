//
//  User+CoreDataProperties.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2018-03-24.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic banned;
@dynamic created_at;
@dynamic current;
@dynamic email;
@dynamic first_name;
@dynamic last_name;
@dynamic modified_at;
@dynamic phone_number;
@dynamic phone_valid;
@dynamic rating;
@dynamic session_id;
@dynamic user_id;
@dynamic valid;
@dynamic profile_photo_url;
@dynamic club;
@dynamic currentClub;
@dynamic location;
@dynamic orders;
@dynamic permissions;
@dynamic photo;

@end
