//
//  Photo+CoreDataProperties.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-19.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Photo+CoreDataProperties.h"

@implementation Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
}

@dynamic created_at;
@dynamic mediaUpdatedAt;
@dynamic mediaURL;
@dynamic photo_id;
@dynamic readyForDisplay;
@dynamic sort_order;
@dynamic thumbUpdatedAt;
@dynamic thumbURL;
@dynamic club;
@dynamic clubLogo;
@dynamic menuItem;
@dynamic user;

@end
