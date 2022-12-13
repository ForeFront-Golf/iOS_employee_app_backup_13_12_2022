//
//  MenuTypeHeaderView.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "MenuTypeHeaderView.h"

@implementation MenuTypeHeaderView

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _menu = object;
    _nameLabel.text = [NSString stringWithFormat:@"%@ Orders",_menu.name];
}

@end
