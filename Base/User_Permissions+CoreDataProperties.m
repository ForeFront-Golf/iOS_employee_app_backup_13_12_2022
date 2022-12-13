//
//  User_Permissions+CoreDataProperties.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-19.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "User_Permissions+CoreDataProperties.h"

@implementation User_Permissions (CoreDataProperties)

+ (NSFetchRequest<User_Permissions *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User_Permissions"];
}

@dynamic permission_id;
@dynamic user_permissions_id;
@dynamic club;
@dynamic user;

@end
