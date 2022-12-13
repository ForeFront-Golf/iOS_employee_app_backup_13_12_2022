//
//  User+CoreDataClass.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-01-17.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "User+CoreDataClass.h"

static User *currentUser = nil;

@implementation User

+ (void)setCurrentUser:(nullable User*)user withSessionId:(nullable NSString*)sessionId
{
    currentUser.current = false;
    currentUser.session_id = nil;
    
    currentUser = user;
    currentUser.current = true;
    currentUser.session_id = sessionId;
    
    [ServerClient setSessionId:user.session_id];
}

+ (User*)currentUser
{
    return currentUser;
}

+ (BOOL)isLoggedIn
{
    if([User currentUser])
    {
        return true;
    }
    
    User *user = [User fetchObjectForPredicate:[NSPredicate predicateWithFormat:@"current = true"]];
    if(user)
    {
        [self setCurrentUser:user withSessionId:user.session_id];
        return true;
    }
    
    return false;
}

+ (void)logout
{
    NSString *url = [NSString stringWithFormat:@"%@/user/%@/logout", kServerURL,[self currentUser].user_id];
    [ServerClient put:url withParameters:nil withBlock:^(NSDictionary *results, NSError *error)
     {
     }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoggingOut object:nil];
    
    [User setCurrentUser:nil withSessionId:nil];
    
    [PKRevealController showRightViewController];
    
    [[UINavigationController getController] setViewControllers:@[[LoginViewController new]]];
    [MainView setActivityIndicatorVisibility:false];
}

- (void)loggingInCompleted
{
    [self.photo fetchDataForKey:kMedia withBlock:^
     {
     }];
    
    if(!self.currentClub)
    {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"club.name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSArray *sortedPermissions = [self.permissions sortedArrayUsingDescriptors:@[descriptor]];
        User_Permissions *permission = sortedPermissions.firstObject;
        self.currentClub = permission.club;
    }
    
    for(User_Permissions *permission in self.permissions)
    {
        [permission.club downloadMenus];
    }
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.location = [Location createObject];
}

- (void)setUser_id:(NSNumber *)user_id
{
    [self willChangeValueForKey:@"user_id"];
    [self setPrimitiveValue:user_id forKey:@"user_id"];
    [self didChangeValueForKey:@"user_id"];
    
    self.location.user_id = user_id;
    if(!self.photo && user_id)
    {
        self.photo = [Photo createObject];
        self.photo.photo_id = self.user_id.stringValue;
    }
}

- (NSString*)fullName
{
    NSString *fullname = [NSString stringWithFormat:@"%@ %@",self.first_name, self.last_name];
    return fullname;
}

@end
