//
//  OrdersViewController.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-28.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersViewController : UIViewController <GMSMapViewDelegate, TableViewResultsDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *buttonGroupView;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property Club *club;
@property TableViewResultsController *resultsController;
@property TableViewResultsController *menuResultsController;
@property NSMutableArray *markers;

@end
