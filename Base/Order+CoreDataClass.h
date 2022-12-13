//
//  Order+CoreDataClass.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-11.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order_Item, User;

NS_ASSUME_NONNULL_BEGIN

@interface Order : NSManagedObject

- (bool)isOrderState:(OrderState)orderState; 

@end

NS_ASSUME_NONNULL_END

#import "Order+CoreDataProperties.h"
