//
//  Order_Item+CoreDataClass.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-11.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Order_Item+CoreDataClass.h"
#import "Menu_Item+CoreDataClass.h"

#import "Order+CoreDataClass.h"

@implementation Order_Item

- (void)addOrder_optionsObject:(Option_Item *)orderOption
{
    NSMutableSet *orderOptions = self.order_options.mutableCopy;
    [orderOptions addObject:orderOption];
    
    [self willChangeValueForKey:@"order_options"];
    [self setPrimitiveValue:orderOptions forKey:@"order_options"];
    [self didChangeValueForKey:@"order_options"];
    
    self.price = @(self.price.integerValue + orderOption.price.integerValue);
}

- (void)removeOrder_optionsObject:(Option_Item *)orderOption
{
    NSMutableSet *orderOptions = self.order_options.mutableCopy;
    [orderOptions removeObject:orderOption];
    
    [self willChangeValueForKey:@"order_options"];
    [self setPrimitiveValue:orderOptions forKey:@"order_options"];
    [self didChangeValueForKey:@"order_options"];
    
    self.price = @(self.price.integerValue - orderOption.price.integerValue);
}

- (bool)hasOption:(Option_Item*)optionItem
{
    return [self.order_options containsObject:optionItem];
}

- (void)clearOptionsForGroup:(Option_Group*)optionGroup;
{
    NSSet *options = [self.order_options filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"option_group == %@",optionGroup]];
    [self removeOrder_options:options];
}

- (void)copyOrderItem:(Order_Item*)orderItem;
{
    [self setValuesForKeysWithDictionary:[orderItem dictionaryWithValuesForKeys:orderItem.entity.attributesByName.allKeys]];
    self.menu_item = orderItem.menu_item;
    [self removeOrder_options:self.order_options];
    [self addOrder_options:orderItem.order_options];
}

@end
