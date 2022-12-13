//
//  AppDelegate.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;
    [OneSignal initWithLaunchOptions:launchOptions appId:@"0a786100-62a9-4630-8751-d4a96833de93" handleNotificationAction:^(OSNotificationOpenedResult *result)
     {
         //move to club corresponding to the notification
         OSNotificationPayload *payload = [[result notification] payload];
         NSDictionary *data = [payload additionalData];
         Club* club = [Club fetchObjectWithId:data[@"Order"][@"club_id"]];
         if(club != [User currentUser].currentClub)
         {//move to club with notification
             [User currentUser].currentClub = club;
             [OneSignal sendTag:@"club_id" value:[User currentUser].currentClub.club_id.stringValue];
             UINavigationController *navController = self.navigationController;
             [navController setViewControllers:@[[OrdersViewController new]] animated:YES];
         }
         [[User currentUser].currentClub downloadOrders];
         [[User currentUser].currentClub downloadUserLocations];
     }];
    
    [[AWSMobileClient sharedInstance] didFinishLaunching:application withOptions:launchOptions];
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1 identityPoolId:@"us-east-1:e8fa1784-aca5-4385-a6e9-527a20028d4c"];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    [GMSServices provideAPIKey:@"AIzaSyDabTryjQDThcMgE1x1FrA7uz-kT48tDbg"];
    
    [self setupControllers];
    return YES;
}

- (void)setupControllers
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    self.window.backgroundColor = [UIColor clearColor];
    _navigationController = [[DDMNavigationController alloc] initWithRootViewController:[LaunchViewController new]];
    [_navigationController setNavigationBarHidden:YES];
    SettingsViewController *settingsViewController = [SettingsViewController new];
    _revealController = [PKRevealController revealControllerWithFrontViewController:_navigationController leftViewController:settingsViewController];
    if (kIsIpad) {
        [_revealController setMinimumWidth:bounds.size.width * 0.65f maximumWidth:bounds.size.width forViewController:settingsViewController];
    } else {
        [_revealController setMinimumWidth:bounds.size.width * 0.8f maximumWidth:bounds.size.width forViewController:settingsViewController];
    }
    
    self.window.rootViewController = _revealController;
    [self.window makeKeyAndVisible];
    _revealController.revealPanGestureRecognizer.delegate = _revealController;
    
    [Globals globals];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[AWSMobileClient sharedInstance] withApplication:application withURL:url withSourceApplication:sourceApplication withAnnotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [CoreData save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[User currentUser].currentClub downloadOrders];
    [[User currentUser].currentClub downloadUserLocations];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [CoreData save];
}

@end
