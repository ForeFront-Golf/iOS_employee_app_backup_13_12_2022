//
//  User_Permissions+CoreDataProperties.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-19.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "User_Permissions+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User_Permissions (CoreDataProperties)

+ (NSFetchRequest<User_Permissions *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *permission_id;
@property (nullable, nonatomic, copy) NSNumber *user_permissions_id;
@property (nullable, nonatomic, retain) Club *club;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
