//
//  User+CoreDataProperties.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2018-03-24.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *banned;
@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nonatomic) BOOL current;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *first_name;
@property (nullable, nonatomic, copy) NSString *last_name;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *phone_number;
@property (nullable, nonatomic, copy) NSNumber *phone_valid;
@property (nullable, nonatomic, copy) NSNumber *rating;
@property (nullable, nonatomic, copy) NSString *session_id;
@property (nullable, nonatomic, copy) NSNumber *user_id;
@property (nullable, nonatomic, copy) NSNumber *valid;
@property (nullable, nonatomic, copy) NSString *profile_photo_url;
@property (nullable, nonatomic, retain) Club *club;
@property (nullable, nonatomic, retain) Club *currentClub;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) NSSet<Order *> *orders;
@property (nullable, nonatomic, retain) NSSet<User_Permissions *> *permissions;
@property (nullable, nonatomic, retain) Photo *photo;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet<Order *> *)values;
- (void)removeOrders:(NSSet<Order *> *)values;

- (void)addPermissionsObject:(User_Permissions *)value;
- (void)removePermissionsObject:(User_Permissions *)value;
- (void)addPermissions:(NSSet<User_Permissions *> *)values;
- (void)removePermissions:(NSSet<User_Permissions *> *)values;

@end

NS_ASSUME_NONNULL_END
