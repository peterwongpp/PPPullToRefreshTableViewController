//
//  PPMasterViewController.h
//  PPPullToRefreshTableViewControllerDemo
//
//  Created by Peter Wong on 20/8/12.
//  Copyright (c) 2012 PeterWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPullToRefreshTableViewController.h"

@class PPDetailViewController;

@interface PPMasterViewController : PPPullToRefreshTableViewController

@property (strong, nonatomic) PPDetailViewController *detailViewController;

@end
