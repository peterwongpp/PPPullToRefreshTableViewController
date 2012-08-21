//
//  PPPullToRefreshTableViewController.m
//  PPPullToRefreshTableViewControllerDemo
//
//  Created by PeterWong on 21/8/12.
//  Copyright (c) 2012 PeterWong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PPPullToRefreshTableViewController.h"

#define TRIGGER_HEIGHT 65.0f
#define HEADER_VIEW_HEIGH 65.0f

#define TEXT_COLOR [UIColor colorWithRed:117.0/255.0 green:138.0/255.0 blue:167.0/255.0 alpha:1.0]
#define TEXT_SHADOW_COLOR [UIColor colorWithWhite:0.9f alpha:1.0f]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f);
#define BORDER_COLOR [UIColor colorWithRed:113.0/255.0 green:120.0/255.0 blue:128.0/255.0 alpha:1.0]
#define BACKGROUND_COLOR [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

@interface PPPullToRefreshTableViewController () {
    BOOL _isDragging;
    
    UIView *_headerView;
    UILabel *_statusLabel;
    UILabel *_lastUpdatedAtLabel;
    UIImageView *_arrowImageView;
    UIActivityIndicatorView *_spinnerActivityIndicatorView;
}

- (void) setup;
- (void) createHeaderView;
- (void) releaseHeaderView;

@end

@implementation PPPullToRefreshTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createHeaderView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseHeaderView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Internal methods

- (void) setup
{
    if (_pullToRefreshText == (id)[NSNull null] || _pullToRefreshText.length == 0) _pullToRefreshText = @"Pull to refresh...";
    if (_releaseToRefreshText == (id)[NSNull null] || _releaseToRefreshText.length == 0) _releaseToRefreshText = @"Release to refresh...";
    if (_refreshingText == (id)[NSNull null] || _refreshingText.length == 0) _refreshingText = @"Loading...";
}

- (void) createHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    _headerView.backgroundColor = BACKGROUND_COLOR;
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGFloat width = _headerView.bounds.size.width;
    CGFloat height = _headerView.bounds.size.height;
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, height-52.0f, width, 20.0f)];
    _statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _statusLabel.textColor = TEXT_COLOR;
    _statusLabel.textAlignment = UITextAlignmentCenter;
    _statusLabel.shadowColor = TEXT_SHADOW_COLOR;
    _statusLabel.shadowOffset = TEXT_SHADOW_OFFSET;
    _statusLabel.backgroundColor = BACKGROUND_COLOR;
    _statusLabel.opaque = YES;
    _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_headerView addSubview:_statusLabel];
    
    _lastUpdatedAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, height-30.0f, width, 20.0f)];
    _lastUpdatedAtLabel.font = [UIFont systemFontOfSize:12.0f];
    _lastUpdatedAtLabel.textColor = TEXT_COLOR;
    _lastUpdatedAtLabel.textAlignment = UITextAlignmentCenter;
    _lastUpdatedAtLabel.shadowColor = TEXT_SHADOW_COLOR;
    _lastUpdatedAtLabel.shadowOffset = TEXT_SHADOW_OFFSET;
    _lastUpdatedAtLabel.backgroundColor = BACKGROUND_COLOR;
    _lastUpdatedAtLabel.opaque = YES;
    _lastUpdatedAtLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_headerView addSubview:_lastUpdatedAtLabel];
    
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25.0f, height-65.0f, 23.0f, 53.0f)];
    _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    _arrowImageView.image = [UIImage imageNamed:@"pullToRefreshArrow.png"];
    [_headerView addSubview:_arrowImageView];
    
    _spinnerActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(25.0f, height-38.0f, 20.0f, 20.0f)];
    _spinnerActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _spinnerActivityIndicatorView.hidesWhenStopped = YES;
    [_headerView addSubview:_spinnerActivityIndicatorView];
    
    [self.tableView addSubview:_headerView];
}

- (void) releaseHeaderView
{
    [_spinnerActivityIndicatorView removeFromSuperview]; _spinnerActivityIndicatorView = nil;
    [_arrowImageView removeFromSuperview]; _arrowImageView = nil;
    [_lastUpdatedAtLabel removeFromSuperview]; _lastUpdatedAtLabel = nil;
    [_statusLabel removeFromSuperview]; _statusLabel = nil;
    [_headerView removeFromSuperview]; _headerView = nil;
}

# pragma mark - ScrollView delegates

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_isRefreshing) return;
    _isDragging = true;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isRefreshing || !_isDragging) return;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (scrollView.contentOffset.y >= -TRIGGER_HEIGHT && scrollView.contentOffset.y < 0.0f) {
            _statusLabel.text = _pullToRefreshText;
            _arrowImageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
        } else if (scrollView.contentOffset.y < -TRIGGER_HEIGHT) {
            _statusLabel.text = _releaseToRefreshText;
            _arrowImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }
    }];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_isRefreshing) return;
    
    _isDragging = NO;
    if (scrollView.contentOffset.y < -TRIGGER_HEIGHT) {
        [self willRefresh];
    }
}

#pragma mark - Refreshing methods

- (void) willRefresh
{
    _isRefreshing = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(HEADER_VIEW_HEIGH, 0, 0, 0);
        _statusLabel.text = _refreshingText;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        _lastUpdatedAtLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:[NSDate date]]];
        
        _arrowImageView.hidden = YES;
        [_spinnerActivityIndicatorView startAnimating];
    }];
    
    [self refreshing];
}

- (void) refreshing
{
    NSLog(@"%s is a placeholder method. You should override this with your reload data logic.", __PRETTY_FUNCTION__);
    NSLog(@"However, remember to call [self stopRefreshing] in your implmenetation of refresh!");
    
    [self performSelector:@selector(didRefresh) withObject:nil afterDelay:2.0];
}

- (void) didRefresh
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        _arrowImageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    } completion:^(BOOL finished) {
        _statusLabel.text = _pullToRefreshText;
        _arrowImageView.hidden = NO;
        [_spinnerActivityIndicatorView stopAnimating];
        
        _isRefreshing = NO;
    }];
}

@end
