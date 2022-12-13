//
//  DDMMarker.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-12.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "DDMMarker.h"

@implementation DDMMarker

- (id)init
{
    if(self = [super init])
    {
        MarkerView *markerView = [[MarkerView alloc] initFromNib];
        self.opacity = 0.8;
        self.iconView = markerView;
        self.groundAnchor = CGPointMake(0.5, 0.5);
        
        CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:kGMSMarkerLayerOpacity];
        fade.fromValue = @0;
        fade.toValue = @1;
        fade.duration = 0.7;
        [self.layer addAnimation:fade forKey:@"fade"];
    }
    return self;
}

@end
