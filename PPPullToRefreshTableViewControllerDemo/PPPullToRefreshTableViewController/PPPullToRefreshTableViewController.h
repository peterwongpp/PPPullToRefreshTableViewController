//
//  PPPullToRefreshTableViewController.h
//  PPPullToRefreshTableViewControllerDemo
//
//  Created by PeterWong on 21/8/12.
//  Copyright (c) 2012 PeterWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPPullToRefreshTableViewController : UITableViewController

@property BOOL isRefreshing;

@property (nonatomic, retain) NSString *pullToRefreshText;
@property (nonatomic, retain) NSString *releaseToRefreshText;
@property (nonatomic, retain) NSString *refreshingText;

- (void) willRefresh;
- (void) refreshing;
- (void) didRefresh;

@end
