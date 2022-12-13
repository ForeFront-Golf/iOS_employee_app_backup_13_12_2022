//
//  LoginViewController.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-03-22.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "LoginViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:false];
    [MainView setNavBarButton:NBT_EmptyLeft];
    [MainView setNavBarButton:NBT_EmptyRight];
    //Avoid gap when using IphoneX
    if (@available(iOS 11.0, *)) {
        [_LoginScrollView setContentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentNever];
    }
}

- (IBAction)forgetButtonPressed
{
}

- (IBAction)loginButtonPressed
{
    [MainView setActivityIndicatorVisibility:YES];
    NSString *url = [NSString stringWithFormat:@"%@/login?full=true", kServerURL];
    NSDictionary *parameters = @{@"email":_emailTextField.text, @"password":_passwordTextField.text};
    [ServerClient post:url withParameters:parameters withBlock:^(NSDictionary *results, NSError *error)
     {
         if(results)
         {
             User *user = [User serializeFrom:results];
             NSString *sessionId = results[@"Session"][@"session_id"];
             [User setCurrentUser:user withSessionId:sessionId];
             [Globals loggingInCompleted];
         }
         else
         {
             [UIAlertController showWithTitle:@"Login Error" message:[error localizedDescription] actions:nil preferredStyle:[UIAlertController getDefaultStyle]];
         }
         [MainView setActivityIndicatorVisibility:false];
     }];
}

- (IBAction)privacyButtonPressed
{
    DocumentViewController *controller = [DocumentViewController new];
    controller.fileName = @"https://s3.amazonaws.com/forefront-userfiles-mobilehub-1269340312/public/legal/ForeOrderPrivacy.pdf";
    [[UINavigationController getController] pushViewController:controller];
    [PKRevealController showRightViewController];
}

- (IBAction)termsButtonPressed
{
    DocumentViewController *controller = [DocumentViewController new];
    controller.fileName = @"https://s3.amazonaws.com/forefront-userfiles-mobilehub-1269340312/public/legal/ForeOrderTerms.pdf";
    [[UINavigationController getController] pushViewController:controller];
    [PKRevealController showRightViewController];
}

@end
