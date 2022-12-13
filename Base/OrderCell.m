//
//  OrderCell.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-28.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "OrderCell.h"
@implementation OrderCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _order = object;
    _sortOrderLabel.text = _order.order_num.stringValue;;
    _nameLabel.text = [_order.user fullName];
    _stateView.backgroundColor = [_order isOrderState:OS_Placed] ? [UIColor gGrey] : [UIColor gYellow];
    if(kIsIpad){
        [_stateView.layer setCornerRadius:7.5f];
    }
    NSDateComponents *components = [[NSDate dateWithTimeIntervalSince1970:_order.created_at.doubleValue] elaspedComponentsForUnits:NSCalendarUnitMinute];
    NSInteger minutes = [components minute];
    NSString *timeString;
    if(minutes < 1){
        NSDateComponents *components = [[NSDate dateWithTimeIntervalSince1970:_order.created_at.doubleValue] elaspedComponentsForUnits:NSCalendarUnitSecond];
        NSInteger second = [components second];
        timeString = [NSString stringWithFormat:@"%ld sec",(long)second];
    } else if(minutes < 60){
        NSString *minutesString = minutes > 1 ? @"mins" : @"min";
        timeString = [NSString stringWithFormat:@"%ld %@",(long)minutes, minutesString];
    } else {
        NSInteger hour = minutes / 60;
        NSInteger min = minutes % 60;
        NSString *hoursString = hour > 1 ? @"hrs" : @"hr";
        NSString *minutesString = min > 1 ? @"mins" : @"min";
        timeString = [NSString stringWithFormat: @"%ld %@ %ld %@", (long)hour, hoursString, (long)min, minutesString];
    }
    _timeLabel.text = timeString;
    
    CLLocationCoordinate2D coordinate = [Globals bestCoordinate];
    NSInteger distance = [_order.user.location distanceToLatitude:coordinate.latitude andLongitude:coordinate.longitude];
    if(distance >= 1000){
        _distanceLabel.text = [NSString stringWithFormat:@"%.1f km",(long)distance/1000.0f];
    } else {
        _distanceLabel.text = [NSString stringWithFormat:@"%ld m",(long)distance];
    }
    NSString *quantity = _order.quantity.integerValue > 1 ? @"items /" : @"item /";
    quantity = [NSString stringWithFormat:@"%@ %@",_order.quantity, quantity];
    _quantityLabel.text = quantity;

    _priceLabel.text = [_order.price_total_with_tax toPriceString];
}

@end
