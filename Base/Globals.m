//
//  Globals.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "Globals.h"

static Globals *globals = nil;
static CGFloat keyboardHeight;
static NSMutableDictionary* tickTockTimes = nil;

///////////////////////////////////////////////////////////////////////////////
@implementation Globals

+ (Globals*)globals
{
    //synchronized for thread safety when initializing
    @synchronized(self)
    {
        if(globals == nil)
        {
            globals = [Globals new];
            [globals setup];
        }
    }
    return globals;
}

+ (CGFloat)keyboardHeight
{
    return keyboardHeight;
}

+ (void)tickForKey:(NSString *)key
{
    tickTockTimes[key] = [NSDate date];
}

+ (void)tockForKey:(NSString *)key
{
    NSTimeInterval timeInterval = -[tickTockTimes[key] timeIntervalSinceNow];
    NSLog(@"Processing time = %f for %@", timeInterval, key);
    [tickTockTimes removeObjectForKey:key];
}

- (void)setup
{
    tickTockTimes = @{}.mutableCopy;

    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIButton class]]].numberOfLines = 0;
    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIButton class]]].adjustsFontSizeToFitWidth = true;
    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIButton class]]].textAlignment = NSTextAlignmentCenter;
    
    [CoreData coreData];
    [MainView view];
    
    _locationManager = [CLLocationManager new];
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [_locationManager requestAlwaysAuthorization];
    }
    
    _mapView = [GMSMapView new];
    _mapView.myLocationEnabled = YES;
    [_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if([User isLoggedIn])
    {
        [MainView setActivityIndicatorVisibility:true];
        NSString *url = [NSString stringWithFormat:@"%@/validate", kServerURL];
        [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
         {
             if(results)
             {
                 [Globals loggingInCompleted];
             }
             else
             {
                 [Globals logout];
             }
             [MainView setActivityIndicatorVisibility:false];
         }];
    }
    else
    {
        [[UINavigationController getController] setViewControllers:@[[LoginViewController new]]];
    }
}

- (void)keyboardChanged:(NSNotification*)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    keyboardHeight = screenBounds.size.height - keyboardFrame.origin.y;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]])
    {
        [User currentUser].location.lat = @(_mapView.myLocation.coordinate.latitude);
        [User currentUser].location.lon = @(_mapView.myLocation.coordinate.longitude);
    }
}

//need to fix how login works, this is temp till more server function come online
+ (void)loggingInCompleted
{
    User *user = [User currentUser];
    [user loggingInCompleted];
    
    [OneSignal syncHashedEmail:user.email];
    [OneSignal sendTag:@"email" value:user.email];
    [OneSignal sendTag:@"employee" value:@"true"];
    [OneSignal sendTag:@"club_id" value:user.currentClub.club_id.stringValue];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLoggingInCompleted object:nil];
    [self setupViewControllers];
    [self updateLocations];
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertAction *action1 = [UIAlertAction initWithTitle:@"Settings" forTarget:[UIApplication sharedApplication] andSelector:@selector(openURL:) withObject:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        UIAlertAction *action2 = [UIAlertAction initWithTitle:@"Cancel"];
        [UIAlertController showWithTitle:@"Location Permission Denied" message:@"Please go to Settings and enable Location Service for ForeOrder Employee." actions:@[action1,action2]preferredStyle:[UIAlertController getDefaultStyle]];
        
    }
}

+ (void)setupViewControllers
{
    [[UINavigationController getController] setViewControllers:@[[OrdersViewController new]]];
}

+ (void)logout
{
    [User logout];
}

+ (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    dispatch_block_t block = ^
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
    };
    
    if([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

+ (CLLocationCoordinate2D)bestCoordinate
{
    CLLocation *location = self.globals.mapView.myLocation;
    if(location)
    {
        return location.coordinate;
    }
    else
    {
        Club *club = [User currentUser].currentClub;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(club.lat.doubleValue,club.lon.doubleValue);
        return coordinate;
    }
}

+ (void)updateLocations
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(updateLocations) withObject:nil afterDelay:kUpdateLocationsInteval];
    [[User currentUser].currentClub downloadUserLocations];
    [[User currentUser].currentClub downloadOrders];
}

@end

