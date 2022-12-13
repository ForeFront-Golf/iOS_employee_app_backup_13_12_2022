//
//  UIImagePickerController+Extend.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-01-27.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (Extend)

+ (UIImagePickerController*)createImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType andDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;

@end
