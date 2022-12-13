//
//  LoginViewController.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-03-22.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet DDMTextField *emailTextField;
@property (weak, nonatomic) IBOutlet DDMTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *LoginScrollView;
@property (weak, nonatomic) IBOutlet UIView *LoginContentView;

@end
