//
//  NSFileManager+Extend.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extend)

+ (NSString*)pathForDocuments;
+ (NSString*)pathForDirectory:(NSSearchPathDirectory)directory;

@end
