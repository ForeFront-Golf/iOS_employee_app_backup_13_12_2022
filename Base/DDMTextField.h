//
//  DDMTextField.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const kTextFieldCancelled = 98;

@interface DDMTextField : UITextField <UITextFieldDelegate>

@property IBInspectable BOOL resetScrollOnResign;
@property IBInspectable BOOL isCurrency;
@property IBInspectable BOOL isPhoneNumber;
@property IBInspectable NSInteger maxLength;
@property IBInspectable NSInteger textXInset;
@property IBInspectable UIColor *placeholderColor;

@property IBOutlet UIView *nextField;
@property IBOutlet UIScrollView *scrollView;

@property (nonatomic,assign) id<UITextFieldDelegate> forwardDelegate;

@end
