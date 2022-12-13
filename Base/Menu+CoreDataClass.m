//
//  Menu+CoreDataClass.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Menu+CoreDataClass.h"
#import "Club+CoreDataClass.h"
#import "Menu_Item+CoreDataClass.h"
@implementation Menu

- (void)setSelected:(NSNumber *)selected
{
    [self willChangeValueForKey:@"selected"];
    [self setPrimitiveValue:selected forKey:@"selected"];
    [self didChangeValueForKey:@"selected"];
    
    [self.orders makeObjectsPerformSelector:@selector(makeDirty)];
}

@end
