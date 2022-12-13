//
//  Order_Item+CoreDataProperties.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-19.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Order_Item+CoreDataProperties.h"

@implementation Order_Item (CoreDataProperties)

+ (NSFetchRequest<Order_Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Order_Item"];
}

@dynamic created_at;
@dynamic modified_at;
@dynamic order_item_id;
@dynamic price;
@dynamic quantity;
@dynamic special_request;
@dynamic menu_item;
@dynamic order;
@dynamic order_options;

@end
