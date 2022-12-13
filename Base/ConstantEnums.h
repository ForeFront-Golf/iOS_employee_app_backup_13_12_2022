//
//  ConstantEnums.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#ifndef _ConstantEnums_h
#define _ConstantEnums_h

#import <Foundation/Foundation.h>

//////////////////////////////////////////////////////////
enum
{
    NBT_Back,
    NBT_Settings,
    NBT_Close,
    NBT_EmptyLeft,
    NBT_Next,
    NBT_Notification,
    NBT_Call,
    NBT_EmptyRight,
    NBT_Title,
    NBT_Profile,
};
typedef NSInteger NavButtonType;

enum
{
    OS_Placed,
    OS_Received,
    OS_Completed
};
typedef NSInteger OrderState;

#endif /* ConstantEnums_h */
