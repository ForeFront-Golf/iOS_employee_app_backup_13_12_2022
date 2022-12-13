//
//  SettingsViewController.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _deleteDatabaseButton.hidden = !kIsSimulator;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateView];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updateView];
}

- (void)updateView
{
    User *user = [User currentUser];
    _nameLabel.text = user.currentClub.name;
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"v%@",version];
}

- (IBAction)editButtonPressed
{
}

- (IBAction)clubButtonPressed
{
    [[UINavigationController getController] pushViewController:[ClubViewController new]];
    [PKRevealController showRightViewController];
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
- (IBAction)deleteDatabaseButtonPressed
{
    [CoreData deleteAllObjects];
    [Globals logout];
    [PKRevealController showRightViewController];
}

- (IBAction)deleteUser
{
    NSError * error = nil;
    NSURLResponse * response = nil;
    User *user = [User currentUser];
    NSString *url = [NSString stringWithFormat:@"%@/delete_user/%@", kServerURL, user.user_id];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(!error)
    {
        [Globals logout];
        [user deleteObject];
        [PKRevealController showRightViewController];
    }
}

- (IBAction)logoutButtonPressed
{
    [Globals logout];
}

@end
