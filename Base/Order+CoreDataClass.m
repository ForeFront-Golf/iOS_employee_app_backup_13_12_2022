//
//  Order+CoreDataClass.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-11.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Order+CoreDataClass.h"
#import "Order_Item+CoreDataClass.h"

#import "User+CoreDataClass.h"

@implementation Order

- (bool)isOrderState:(OrderState)orderState
{
    if(orderState == OS_Placed)
    {
        return [self.current_state isEqualToString:@"placed"];
    }
    else if(orderState == OS_Received)
    {
        return [self.current_state isEqualToString:@"received"];
    }
    else
    {
        return [self.current_state isEqualToString:@"completed"];
    }
}

@end
