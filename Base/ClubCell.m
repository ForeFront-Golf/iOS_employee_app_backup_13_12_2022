//
//  ClubCell.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-02.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "ClubCell.h"

@implementation ClubCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _permission = object;
    _nameLabel.text = _permission.club.name;
    _button.selected = [User currentUser].currentClub == _permission.club;
}

- (IBAction)buttonSelected
{
    User *user = [User currentUser];
    user.currentClub = _permission.club;
    [OneSignal sendTag:@"club_id" value:user.currentClub.club_id.stringValue];
    
    ClubViewController *controller = [self viewController];
    [controller.tableView reloadData];
    [controller.navigationController setViewControllers:@[[OrdersViewController new]]];
}

@end
