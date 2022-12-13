//
//  OrderItemCell.m
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-04-12.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "OrderItemCell.h"
@implementation OrderItemCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _orderItem = object;
    _nameLabel.text = _orderItem.menu_item.name;
    
    _quantityLabel.text = _orderItem.quantity.stringValue;
    _priceLabel.text = [_orderItem.price toPriceString];
    
    _detailsLabel.text = @"";
    
    NSArray *sortedOptions = [_orderItem.order_options sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
    for(int i = 0; i < sortedOptions.count; i++)
    {
        Option_Item *option = sortedOptions[i];
        NSString *detail = option.name;
        if(option.price.doubleValue > 0)
        {
            detail = [NSString stringWithFormat:@"%@ (%@)",detail, option.price.toPriceString];
        }
        
        if(i < sortedOptions.count - 1)
        {
            detail =  [detail stringByAppendingString:@"\n"];
        }
        
        _detailsLabel.text = [_detailsLabel.text stringByAppendingString:detail];
    }
    
    _notesLabel.text = [_orderItem.special_request trimWhitespace];
    _notesTitleLabel.alpha = _notesLabel.text.length;

    if(kIsIpad)
    {
        NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:_detailsLabel.text];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:2];
        [attrString addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, _detailsLabel.text.length)];
        _detailsLabel.attributedText = attrString;
    }
}

@end
