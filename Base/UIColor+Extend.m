//
//  UIColor+Extend.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UIColor+Extend.h"

@implementation UIColor (Extend)

+ (UIColor*)gBlack
{
    return [UIColor colorWithRed:14 / 255.f green:40 / 255.f blue:61 / 255.f alpha:1];
}

+ (UIColor*)gWhite
{
    return [UIColor colorWithRed:244 / 255.f green:245 / 255.f blue:246 / 255.f alpha:1];
}

+ (UIColor*)gPink
{
    return [UIColor colorWithRed:252 / 255.f green:107 / 255.f blue:91 / 255.f alpha:1];
}

+ (UIColor*)gGreen
{
    return [UIColor colorWithRed: 0.16 green:0.85 blue:0.59 alpha:1];
}

+ (UIColor*)gYellow
{
    return [UIColor colorWithRed:246 / 255.f green:221/ 255.f blue:46 / 255.f alpha:1];
}

+ (UIColor*)gGrey
{
    return [UIColor colorWithRed:145 / 255.f green:158/ 255.f blue:167 / 255.f alpha:1];
}

- (UIImage*)image
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
