//
//  ClubViewController.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-02.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "ClubViewController.h"

@interface ClubViewController ()

@end

@implementation ClubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User_Permissions"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"user = %@",[User currentUser]];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"club.name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    _resultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forTableView:_tableView andCellIdentifiers:@[@"ClubCell"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:true];
    [MainView setNavBarButton:NBT_Close];
    [MainView setNavBarButton:NBT_EmptyRight];
    [MainView setTitleLabel:@"Change Course"];
    
}

@end
