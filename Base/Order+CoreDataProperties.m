//
//  Order+CoreDataProperties.m
//  GolfEmployee
//
//  Created by Chenyao Yang on 2018-05-25.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Order+CoreDataProperties.h"

@implementation Order (CoreDataProperties)

+ (NSFetchRequest<Order *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Order"];
}

@dynamic created_at;
@dynamic current_state;
@dynamic delivery;
@dynamic fulfilled;
@dynamic modified_at;
@dynamic order_id;
@dynamic order_num;
@dynamic price_total;
@dynamic price_total_with_tax;
@dynamic quantity;
@dynamic tax_amount;
@dynamic member_code;
@dynamic club;
@dynamic items;
@dynamic menu;
@dynamic user;

@end
