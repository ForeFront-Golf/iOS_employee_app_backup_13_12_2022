//
//  OrderViewController.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-12.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController <NSFetchedResultsControllerDelegate, TableViewResultsDataSource>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *hstLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderStateButton;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UILabel *subtotalTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *HSTTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *membercode;

@property Order *order;
@property TableViewResultsController *resultsController;
@property DDMResultsController *userResultsController;
@property DDMResultsController *deviceResultsController;
@property DDMResultsController *orderResultsController;
@property DDMMarker *marker;
@property NSString *currentState;

@end
