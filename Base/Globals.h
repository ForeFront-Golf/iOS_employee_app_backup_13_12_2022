//
//  Globals.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef GolfEmployee_Globals_h
#define GolfEmployee_Globals_h

CG_INLINE CGRect CGRectMakeWithOrigin(CGFloat x, CGFloat y)
{
    CGRect rect;
    rect.origin.x = x; rect.origin.y = y;
    rect.size.width = 0; rect.size.height = 0;
    return rect;
}

CG_INLINE CGRect CGRectMakeWithSize(CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = 0; rect.origin.y = 0;
    rect.size.width = width; rect.size.height = height;
    return rect;
}

CG_INLINE CGFloat distanceBetweenPoints(CGPoint point0, CGPoint point1)
{
    return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2));
}

CG_INLINE CGFloat scaleMinBetweenSizes(CGSize size0, CGSize size1)
{
    CGFloat scaleX = size0.width / size1.width;
    CGFloat scaleY = size0.height / size1.height;
    CGFloat scale = MIN(scaleX, scaleY);
    return scale;
}

CG_INLINE CGFloat scaleMaxBetweenSizes(CGSize size0, CGSize size1)
{
    CGFloat scaleX = size0.width / size1.width;
    CGFloat scaleY = size0.height / size1.height;
    CGFloat scale = MAX(scaleX, scaleY);
    return scale;
}

@interface Globals : NSObject

+ (Globals*)globals;
+ (CGFloat)keyboardHeight;
+ (void)tickForKey:(NSString*)key;
+ (void)tockForKey:(NSString*)key;
+ (void)loggingInCompleted;
+ (void)setupViewControllers;
+ (void)logout;
+ (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
+ (CLLocationCoordinate2D)bestCoordinate;

@property GMSMapView *mapView;
@property CLLocationManager *locationManager;       //only used to trigger correct location authorization message with all 3 options.  Otherwise, GoogleMaps controls authorization and they are doing it in 2 separate steps with 2 options each time.

@end

#endif
