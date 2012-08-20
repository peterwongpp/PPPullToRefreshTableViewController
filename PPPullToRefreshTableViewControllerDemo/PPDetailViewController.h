//
//  PPDetailViewController.h
//  PPPullToRefreshTableViewControllerDemo
//
//  Created by Peter Wong on 20/8/12.
//  Copyright (c) 2012 PeterWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
