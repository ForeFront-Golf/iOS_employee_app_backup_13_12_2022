//
//  OrderViewController.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-12.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "OrderViewController.h"


@interface OrderViewController ()

@end

@implementation OrderViewController

bool isDisappearing;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [MainView respondsToSelector:nil];
    
    [_order.club downloadOrder:_order];
    _marker = [DDMMarker new];
    _marker.order = _order;
    _marker.map = _mapView;
    
    _mapView.mapType = kGMSTypeHybrid;
    _mapView.myLocationEnabled = true;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_order.user.location.lat.doubleValue longitude:_order.user.location.lon.doubleValue zoom:kMapZoomLevel];
    [_mapView setCamera:camera];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Order_Item"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"order = %@",_order];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"menu_item.name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    _resultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forTableView:_tableView andCellIdentifiers:@[@"OrderItemCell"]];
    
    _deviceResultsController = [DDMResultsController controllerForDelegate:self forObject:[User currentUser]];
    _userResultsController = [DDMResultsController controllerForDelegate:self forObject:_order.user];
    _orderResultsController = [DDMResultsController controllerForDelegate:self forObject:_order];
    [_order.user fetchDataForKey:kMedia];
    
    
    if(kIsIpad)
    {
        CGRect f = _userView.frame;
        f.size.height = 648;
        _userView.frame = f;
        [_imageView.layer setCornerRadius:67.5f];
        [_stateView.layer setCornerRadius:7.5f];
    }
    _currentState = _order.current_state;
    [self updateView];

}

- (void)removeNSFetchedResultsControllerDelegates {
    _deviceResultsController = nil;
    _userResultsController = nil;
    _orderResultsController = nil;
}

-(void)viewWillDisappear:(BOOL)animated {
    [self removeNSFetchedResultsControllerDelegates];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Back];
    if (kIsIPhone)
    {
        [MainView setNavBarButton:NBT_Call];
    }
    [MainView setTitleLabel:@"Order Details"];
    [self updateView];
}

- (bool)navButtonPressed:(NavButtonType)type
{
    if(type == NBT_Call)
    {
        NSString *phoneNumber = [[_order.user.phone_number componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"() -"]] componentsJoinedByString: @""];
        NSURL *phoneNumberURL = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
        [[UIApplication sharedApplication] openURL:phoneNumberURL options:@{} completionHandler:^(BOOL success) {}];
    }
    return false;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if(![_currentState isEqualToString:_order.current_state])
    {
        [self orderChangedByOthers];
        _currentState = _order.current_state;
    }
    //Check to Pop View if is completed
    if([_order isOrderState:OS_Completed])
    {
        
    }
    [self updateView];
}

- (void)updateView
{
    _orderNumberLabel.text = _order.order_num.stringValue;
    _imageView.image = [_order.user getBestImage];
    _nameLabel.text = [_order.user fullName];
    _headerPriceLabel.text = _order.price_total_with_tax.toPriceString;
    if(![_order.member_code  isEqual: @""] && _order.member_code){
        _membercode.text =[NSString stringWithFormat:@"Member ID: %@", _order.member_code];
    }
    
    NSDateComponents *components = [[NSDate dateWithTimeIntervalSince1970:_order.created_at.doubleValue] elaspedComponentsForUnits:NSCalendarUnitMinute];
    NSInteger minutes = [components minute];
    NSString *timeString;
    if(minutes < 1)
    {
        NSDateComponents *components = [[NSDate dateWithTimeIntervalSince1970:_order.created_at.doubleValue] elaspedComponentsForUnits:NSCalendarUnitSecond];
        NSInteger second = [components second];
        timeString = [NSString stringWithFormat:@"%ld sec",(long)second];
    }
    else if
        (minutes < 60){
        NSString *minutesString = minutes > 1 ? @"mins" : @"min";
        timeString = [NSString stringWithFormat:@"%ld %@",(long)minutes, minutesString];
    }
    else
    {
        NSInteger hour = minutes / 60;
        NSInteger min = minutes % 60;
        NSString *hoursString = hour > 1 ? @"hrs" : @"hr";
        NSString *minutesString = min > 1 ? @"mins" : @"min";
        timeString = [NSString stringWithFormat: @"%ld %@ %ld %@", (long)hour, hoursString, (long)min, minutesString];
    }
    _timeLabel.text = timeString;
    
    if([_order isOrderState:OS_Placed])
    {
        _stateLabel.text = @"Unconfirmed";
        _stateView.backgroundColor = [UIColor gGrey];
        _orderStateButton.backgroundColor = [UIColor gPink];
        [_orderStateButton setTitle:@"Mark order as received" forState:UIControlStateNormal];
    }
    else
    {
        _stateLabel.text = @"In Progress";
        _stateView.backgroundColor = [UIColor gYellow];
        _orderStateButton.backgroundColor = [UIColor gGreen];
        [_orderStateButton setTitle:@"Mark order as complete" forState:UIControlStateNormal];
    }
    
    CLLocationCoordinate2D coordinate = [Globals bestCoordinate];
    NSInteger distance = [_order.user.location distanceToLatitude:coordinate.latitude andLongitude:coordinate.longitude];
    if(distance >= 1000)
    {
        _distanceLabel.text = [NSString stringWithFormat:@"%.1f km",(long)distance/1000.0f];
    }
    else
    {
        _distanceLabel.text = [NSString stringWithFormat:@"%ld m",(long)distance];
    }
    NSString *menuName = _order.menu.name;
    NSString *quantity = _order.quantity.integerValue > 1 ? @"items" : @"item";
    quantity = [NSString stringWithFormat:@"%@ %@ from %@",_order.quantity, quantity, menuName];
    _quantityLabel.text = quantity;
    
    if(_order.club.show_tax){
        _subtotalLabel.text = _order.price_total.toPriceString;
        _hstLabel.text = _order.tax_amount.toPriceString;
        
    }else {
        _subtotalLabel.text = @"";
        _hstLabel.text = @"";
        _subtotalTextLabel.text = @"";
        _HSTTextLabel.text = @"";
    }
    _totalLabel.text = _order.price_total_with_tax.toPriceString;
    
    _marker.position = CLLocationCoordinate2DMake(_marker.order.user.location.lat.doubleValue, _marker.order.user.location.lon.doubleValue);
    MarkerView *markerView = (MarkerView*)_marker.iconView;
    markerView.label.text = _marker.order.order_num.stringValue;
    markerView.label.textColor = [UIColor gPink];
    markerView.layer.borderColor = [UIColor gPink].CGColor;
    [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:_order.user.location.lat.doubleValue longitude:_order.user.location.lon.doubleValue zoom:_mapView.camera.zoom]];
}

- (IBAction)orderStateButtonPressed
{
    UIAlertAction *action1 = [UIAlertAction initWithTitle:@"Yes" forTarget:self andSelector:@selector(orderStateChanged)];
    UIAlertAction *action2 = [UIAlertAction initWithTitle:@"No"];
    NSString *title = [_order isOrderState:OS_Placed] ? @"Do you want to mark this order as received?" : @"Do you want to mark this order as complete?";
    
    [UIAlertController showWithTitle:title message:nil actions:@[action1,action2] preferredStyle:[UIAlertController getDefaultStyle]];
    
}

- (void)orderStateChanged
{
    [self attemptToMarkOrderState];
}

- (void)attemptToMarkOrderState
{
    bool makeComplete = [_order isOrderState:OS_Received];
    NSString *currentState = makeComplete ? @"completed" : @"received";
    bool fulfilled = makeComplete;
    [MainView setActivityIndicatorVisibility:true];
    NSString *url = [NSString stringWithFormat:@"%@/club/%@/order/%@",kServerURL,_order.club.club_id,_order.order_id];
    NSDictionary *parameters = @{@"current_state":currentState, @"fulfilled":@(fulfilled)};
    [ServerClient put:url withParameters:parameters withBlock:^(NSDictionary *results, NSError *error)
     {
         [MainView setActivityIndicatorVisibility:false];
         if(results)
         {
             _currentState = results[@"Order"][@"current_state"];
             [_order serializeFrom:results[@"Order"]];
             if ([_order isOrderState:OS_Completed]) {
                 [self.navigationController popViewController];
             }
         }
         else
         {
             [UIAlertController showWithTitle:[NSString stringWithFormat:@"The order could not be marked as %@", currentState]];
         }
     }];
}


- (void)orderChangedByOthers
{
    if([_order isOrderState:OS_Completed])
    {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"A fellow employee has just completed this order."
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [self.navigationController popViewController];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        [UIAlertController showWithTitle:@"A fellow employee has just updated the status of this order."];
    }
}

@end
