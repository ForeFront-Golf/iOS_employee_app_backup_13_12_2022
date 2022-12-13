//
//  ClubViewController.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-02.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubViewController : UIViewController <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property TableViewResultsController *resultsController;

@end
