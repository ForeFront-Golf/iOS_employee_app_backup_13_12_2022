//
//  Club+CoreDataClass.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Club+CoreDataClass.h"
#import "Course+CoreDataClass.h"
#import "Menu+CoreDataClass.h"
@implementation Club

- (void)setClub_id:(NSNumber *)club_id
{
    [self willChangeValueForKey:@"club_id"];
    [self setPrimitiveValue:club_id forKey:@"club_id"];
    [self didChangeValueForKey:@"club_id"];
    
    if(!self.photo)
    {
        self.photo = [Photo createObject];
        self.photo.photo_id = [NSString stringWithFormat:@"club_%@",club_id];
    }
    if(!self.logoPhoto)
    {
        self.logoPhoto = [Photo createObject];
        self.logoPhoto.photo_id = [NSString stringWithFormat:@"logo_%@",club_id];
    }
}

- (void)downloadMenus
{
    NSString *url = [NSString stringWithFormat:@"%@/club/%@/menu?full=true", kServerURL,self.club_id];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
         for(NSDictionary *menuData in results[@"Menu"])
         {
             [Menu serializeFrom:menuData];
         }
     }];
}

- (void)downloadOrders
{
    NSNumber *lastModifiedAt = [Order getLastModifiedAtWithPredicate:[NSPredicate predicateWithFormat:@"club = %@",self]];
    NSString *url = [NSString stringWithFormat:@"%@/club/%@/order?full=true&modified_at=%@", kServerURL,self.club_id,lastModifiedAt];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
         for(NSDictionary *orderData in results[@"Order"])
         {
             [Order serializeFrom:orderData];
         }
     }];
}

- (void)downloadOrder:(Order *)order
{
    NSString *url = [NSString stringWithFormat:@"%@/club/%@/order/%@",kServerURL,self.club_id,order.order_id];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
         for(NSDictionary *orderData in results[@"Order"])
         {
             [order serializeFrom:orderData];
         }
     }];
}

- (void)downloadUserLocations
{
    NSString *url = [NSString stringWithFormat:@"%@/club/%@/location?menu_ids=[%@]", kServerURL,self.club_id, [self getmenuIDString]];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
         //update modified at
         for(NSDictionary *locationData in results[@"User_Location"])
         {
             User *user = [User getObjectWithId:locationData[@"user_id"]];
             user.location.lat = locationData[@"lat"];
             user.location.lon = locationData[@"lon"];
             user.location.created_at = locationData[@"time"];
         }
     }];
}

- (void)prepareForDeletion
{
    [super prepareForDeletion];
    
    [[NSFileManager defaultManager] removeItemAtPath:[self.photo getPathForKey:kMedia] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self.logoPhoto getPathForKey:kMedia] error:nil];
}

-(NSString*)getmenuIDString
{
    NSString *menuIDString = @"";
    for (Menu *menu in self.menus){
        menuIDString = [menuIDString stringByAppendingString: [NSString stringWithFormat:@"%@", menu.menu_id]];
        menuIDString = [menuIDString stringByAppendingString: @","];
    }
    
    NSRange lastComma = [menuIDString rangeOfString:@"," options:NSBackwardsSearch];
    if(lastComma.location != NSNotFound) {
        menuIDString = [menuIDString stringByReplacingCharactersInRange:lastComma withString: @""];
    }
    return  menuIDString;
}

@end
