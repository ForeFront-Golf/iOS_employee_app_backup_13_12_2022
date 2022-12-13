//
//  Club+CoreDataProperties.m
//  GolfEmployee
//
//  Created by Chenyao Yang on 2018-05-16.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Club+CoreDataProperties.h"

@implementation Club (CoreDataProperties)

+ (NSFetchRequest<Club *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Club"];
}

@dynamic address;
@dynamic club_id;
@dynamic created_at;
@dynamic desc;
@dynamic lat;
@dynamic lon;
@dynamic modified_at;
@dynamic name;
@dynamic phone_number;
@dynamic photo_url;
@dynamic photo_url_thumb;
@dynamic valid;
@dynamic show_tax;
@dynamic courses;
@dynamic currentClub;
@dynamic logoPhoto;
@dynamic menus;
@dynamic orders;
@dynamic permissions;
@dynamic photo;
@dynamic users;

@end
