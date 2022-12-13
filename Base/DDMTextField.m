//
//  DDMTextField.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "DDMTextField.h"

@implementation DDMTextField

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    NSString *placeholderString = self.placeholder;
    if(!placeholderString)
    {
        placeholderString = @"";
    }
    
    if(_placeholderColor)
    {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderString attributes:@{NSForegroundColorAttributeName:_placeholderColor}];
    }
    
    if(self.keyboardType == UIKeyboardTypeNumberPad)
    {
        [self addToolbarToKeyboard];
    }
}

- (void) setDelegate:(id<UITextFieldDelegate>)delegate
{
    [super setDelegate:self];
    _forwardDelegate = delegate;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    [super setReturnKeyType:returnKeyType];
    
    if(self.keyboardType == UIKeyboardTypeNumberPad)
    {
        UIToolbar *toolbar = (UIToolbar*)self.inputAccessoryView;
        if(toolbar)
        {
            for(UIBarButtonItem *doneButton in toolbar.items)
            {
                if(doneButton.tag == 1)
                {
                    NSString *returnKeyString = @"Done";
                    if(self.returnKeyType == UIReturnKeyNext)
                    {
                        returnKeyString = @"Next";
                    }
                    doneButton.title = returnKeyString;
                    doneButton.tintColor = [UIColor lightTextColor];
                }
            }
        }
    }
}

- (id)customOverlayContainer
{
    return self;
}

- (void)addToolbarToKeyboard
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,320,44.0)];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent = NO;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    cancelBtn.tintColor = [UIColor lightTextColor];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    
    NSString *returnKeyString = @"Done";
    if(self.returnKeyType == UIReturnKeyNext)
    {
        returnKeyString = @"Next";
    }
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:returnKeyString style:UIBarButtonItemStyleDone target:self action:@selector(donePressed)];
    doneBtn.tag = 1;
    doneBtn.tintColor = [UIColor lightTextColor];
    [barItems addObject:doneBtn];
    [toolbar setItems:barItems animated:YES];
    self.inputAccessoryView = toolbar;
}

- (void)cancelPressed
{
    NSInteger tag = self.tag;
    self.tag = kTextFieldCancelled;
    [self.superview endEditing:YES];
    self.tag = tag;
}

- (void)donePressed
{
    [self textFieldShouldReturn:self];
}

- (BOOL)endEditing:(BOOL)force
{
    return [super endEditing:force];
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [super resignFirstResponder];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if(self.textAlignment == NSTextAlignmentCenter)
    {
        return [super textRectForBounds:bounds];
    }
    else
    {
        return CGRectInset(bounds, _textXInset, 0);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    if(self.textAlignment == NSTextAlignmentCenter)
    {
        return [super textRectForBounds:bounds];
    }
    else
    {
        return CGRectInset(bounds, _textXInset, 0);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([_forwardDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
    {
        return [_forwardDelegate textFieldShouldBeginEditing:textField];
    }
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification object:nil userInfo:nil];
    [_scrollView scrollToView:textField];
    
    if([_forwardDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
    {
        [_forwardDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if([_forwardDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
    {
        return [_forwardDelegate textFieldShouldEndEditing:textField];
    }
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_scrollView setContentOffset:CGPointZero animated:YES];
    if([_forwardDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
    {
        [_forwardDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    bool returnValue = true;
    if(_maxLength)
    {
        if(self.text.length + string.length > _maxLength && range.length == 0)
        {
            return NO;
        }
    }
    
    if(_isCurrency)
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [formatter setLenient:YES];
        [formatter setGeneratesDecimalNumbers:YES];
        
        NSString *replaced = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSDecimalNumber *amount = (NSDecimalNumber*) [formatter numberFromString:replaced];
        if (amount == nil)
        {
            return NO;                      // Something screwed up the parsing. Probably an alpha character.
        }
        // If the field is empty (the inital case) the number should be shifted to
        // start in the right most decimal place.
        short powerOf10 = 0;
        if ([textField.text isEqualToString:@""])
        {
            powerOf10 = -formatter.maximumFractionDigits;
        }
        // If the edit point is to the right of the decimal point we need to do
        // some shifting.
        else if (range.location + formatter.maximumFractionDigits >= textField.text.length)
        {
            // If there's a range of text selected, it'll delete part of the number
            // so shift it back to the right.
            if (range.length)
            {
                powerOf10 = -range.length;
            }
            // Otherwise they're adding this many characters so shift left.
            else
            {
                powerOf10 = [string length];
            }
        }
        amount = [amount decimalNumberByMultiplyingByPowerOf10:powerOf10];
        
        // Replace the value and then cancel this change.
        textField.text = [formatter stringFromNumber:amount];
        returnValue = false;
    }
    else if(_isPhoneNumber)
    {
        if(string.length)
        {
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSMutableString *formattedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""].mutableCopy;
            
            if(formattedString.length)
            {
                [formattedString insertString:@"(" atIndex:0];
            }
            if(formattedString.length > 3)
            {
                [formattedString insertString:@") " atIndex:4];
            }
            if(formattedString.length > 9)
            {
                [formattedString insertString:@"-" atIndex:9];
            }
            if(formattedString.length < 15)
            {
                textField.text = formattedString;
            }
            return NO;
        }
    }
    if([_forwardDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
    {
        return [_forwardDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return returnValue;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if([_forwardDelegate respondsToSelector:@selector(textFieldShouldClear:)])
    {
        return [_forwardDelegate textFieldShouldClear:textField];
    }
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(_nextField && [_nextField isKindOfClass:[UITextField class]])
    {
        [self resignFirstResponder];
        bool isFirstResponder = [self isFirstResponder];
        UITextField *nextTextField = (UITextField*)_nextField;
        if(!isFirstResponder && ![nextTextField.text trimWhitespace].length)
        {
            [_nextField becomeFirstResponder];
            [_scrollView scrollToView:_nextField];
        }
    }
    else
    {
        [self.superview endEditing:YES];
        if(_nextField && [_nextField isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton*)_nextField;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if([_forwardDelegate respondsToSelector:@selector(textFieldShouldReturn:)])
    {
        return [_forwardDelegate textFieldShouldReturn:textField];
    }
    return TRUE;
}

@end
