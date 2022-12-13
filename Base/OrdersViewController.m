//
//  OrdersViewController.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-28.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "OrdersViewController.h"
@interface OrdersViewController ()

@end

@implementation OrdersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _markers = @[].mutableCopy;
    _club = [User currentUser].currentClub;
    
    _mapView.mapType = kGMSTypeHybrid;
    _mapView.myLocationEnabled = YES;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_club.lat.doubleValue longitude:_club.lon.doubleValue zoom:17];
    [_mapView setCamera:camera];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Order"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"fulfilled = false && menu.selected = true && club = %@",_club];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"menu.name" ascending:YES selector:nil], [[NSSortDescriptor alloc] initWithKey:@"order_num" ascending:YES selector:nil]];
    _resultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:@"menu.name" forTableView:_tableView andCellIdentifiers:@[@"OrderCell"]];
    [_tableView registerNib:[UINib nibWithNibName:@"MenuTypeHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MenuTypeHeaderView"];
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Menu"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"club = %@",_club];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    _menuResultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forTableView:_menuTableView andCellIdentifiers:@[@"MenuTypeCell"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Settings];
    [MainView setNavBarButton:NBT_EmptyRight];
    
    [_club downloadOrders];
    [_club downloadUserLocations];
    [self updateView];
    
    
    //Add shadow to List/Map button group
    [_buttonGroupView.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
    [_buttonGroupView.layer setShadowOpacity:0.39];
    [_buttonGroupView.layer setShadowRadius:3.0];
    [_buttonGroupView.layer setShadowOffset:CGSizeMake(0.0f, 2.0f)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateTitleLabel];
}

- (bool)navButtonPressed:(NavButtonType)type
{
    if(type == NBT_Title)
    {
        [self setMenuTableViewVisibility:!_menuTableView.alpha];
    }
    return false;
}

- (void)updateView
{
    [self updateMarkers];
}

- (void)updateTitleLabel
{
    NSString *title;
    NSString *caret = _menuTableView.alpha ? @"▲" : @"▼";
    NSArray *selectedMenus = [_menuResultsController.fetchedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected = true"]];
    if(!selectedMenus.count)
    {
        title = [NSString stringWithFormat:@"Select Menus  %@",caret];
    }
    else if(selectedMenus.count > 1)
    {
        title = [NSString stringWithFormat:@"Multiple Menus  %@",caret];
    }
    else
    {
        Menu *menu = selectedMenus.firstObject;
        title = [NSString stringWithFormat:@"%@  %@",menu.name, caret];
    }
    [MainView setTitleLabel:title];
}

- (void)updateMarkers
{
    NSArray *orders = _resultsController.fetchedObjects;
    NSArray *deletedMarkers = [_markers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT order in %@",orders]];
    [deletedMarkers makeObjectsPerformSelector:@selector(setMap:) withObject:nil];
    [_markers removeObjectsInArray:deletedMarkers];
    NSArray *newOrders = [orders filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT self in %@.order",_markers]];
    
    //Delete order older than one day.
    for(Order *order in orders){
        NSDateComponents *components = [[NSDate dateWithTimeIntervalSince1970:order.created_at.doubleValue] elaspedComponentsForUnits:NSCalendarUnitMinute];
        NSInteger minutes = [components minute];
        if(minutes >=1440){
            [_club removeOrdersObject:order];
        }
    }
    
    for(Order *order in newOrders)
    {
        DDMMarker *marker = [DDMMarker new];
        marker.order = order;
        marker.map = _mapView;
        [_markers addObject:marker];
    }
    
    for(DDMMarker *marker in _markers)
    {
        marker.position = CLLocationCoordinate2DMake(marker.order.user.location.lat.doubleValue, marker.order.user.location.lon.doubleValue);
        marker.zIndex = -marker.order.order_num.intValue;
        MarkerView *markerView = (MarkerView*)marker.iconView;
        markerView.label.text = marker.order.order_num.stringValue;
    }
}

- (void)tableview:(UITableView *)tableView wasChangedByController:(TableViewResultsController *)controller
{
    if(tableView == _tableView)
    {
        [self updateView];
    }
    //Eddy please check this.
    else if(tableView == _menuTableView &&
            [[[self.navigationController viewControllers] lastObject] isKindOfClass:[OrdersViewController class]])
    {
        [self updateTitleLabel];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(kIsIpad){
        return tableView.rowHeight*1.2;
    } else {
        return tableView.rowHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MenuTypeHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MenuTypeHeaderView"];
    if(_resultsController.fetchedObjects.count)
    {
        Order *order = [_resultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        [view setupTableView:tableView withObject:order.menu forOwner:self];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tableView)
    {
        OrderViewController *controller = [OrderViewController new];
        controller.order = [_resultsController objectAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller];
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(DDMMarker *)marker
{
    OrderViewController *controller = [OrderViewController new];
    controller.order = marker.order;
    [self.navigationController pushViewController:controller];
    return true;
}


- (IBAction)listButtonPressed
{
    _listButton.selected = true;
    _listButton.backgroundColor = [UIColor gBlack];
    _mapButton.selected = false;
    _mapButton.backgroundColor = [UIColor gWhite];
    [_mapView animateAlphaTo:0 withDuration:0.3 andDelay:0];
}

- (IBAction)mapButtonPressed
{
    _listButton.selected = false;
    _listButton.backgroundColor = [UIColor gWhite];
    _mapButton.selected = true;
    _mapButton.backgroundColor = [UIColor gBlack];
    [_mapView animateAlphaTo:1 withDuration:0.3 andDelay:0];
}

- (IBAction)menuTableViewTapped:(id)sender
{
    [self setMenuTableViewVisibility:!_menuTableView.alpha];
}

- (void)setMenuTableViewVisibility:(bool)visibility
{
    [_menuTableView animateAlphaTo:!_menuTableView.alpha withDuration:0.3 andDelay:0];
    [self updateTitleLabel];
}

@end
