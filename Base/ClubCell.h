//
//  ClubCell.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-02.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property User_Permissions *permission;

@end
