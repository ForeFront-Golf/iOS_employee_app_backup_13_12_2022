//
//  Order_Item+CoreDataProperties.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-19.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Order_Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Order_Item (CoreDataProperties)

+ (NSFetchRequest<Order_Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSNumber *order_item_id;
@property (nullable, nonatomic, copy) NSNumber *price;
@property (nullable, nonatomic, copy) NSNumber *quantity;
@property (nullable, nonatomic, copy) NSString *special_request;
@property (nullable, nonatomic, retain) Menu_Item *menu_item;
@property (nullable, nonatomic, retain) Order *order;
@property (nullable, nonatomic, retain) NSSet<Option_Item *> *order_options;

@end

@interface Order_Item (CoreDataGeneratedAccessors)

- (void)addOrder_optionsObject:(Option_Item *)value;
- (void)removeOrder_optionsObject:(Option_Item *)value;
- (void)addOrder_options:(NSSet<Option_Item *> *)values;
- (void)removeOrder_options:(NSSet<Option_Item *> *)values;

@end

NS_ASSUME_NONNULL_END
