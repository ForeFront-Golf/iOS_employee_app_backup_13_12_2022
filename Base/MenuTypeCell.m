//
//  MenuTypeCell.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "MenuTypeCell.h"

@implementation MenuTypeCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _menu = object;
    [_button setTitle:_menu.name forState:UIControlStateNormal];
    _button.selected = _menu.selected.boolValue;
//    _button.titleEdgeInsets = UIEdgeInsetsMake(0, [[UIScreen mainScreen] bounds].size.width*0.1, 0, 0);
    _button.imageEdgeInsets = UIEdgeInsetsMake(0, [[UIScreen mainScreen] bounds].size.width*0.9,0, 0);
    [_button imageView].contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)buttonPressed
{
    _menu.selected = @(!_menu.selected.boolValue);
}

@end
