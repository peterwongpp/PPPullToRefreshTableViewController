# PPPullToRefreshTableViewController

Basically this is a subclass of *UITableViewController*, which adds the functionality of pulling downward to refresh (or reload).

## usage

1. Copy the files into your project:
    - *PPPullToRefreshTableViewController.h*
    - *PPPullToRefreshTableViewController.m*
    - *pullToRefreshArrow.png*
    - *pullToRefreshArrow@2x.png*

2. your table view controller should inherit from *PPPullToRefreshTableViewController* (which is a *UITableViewController* subclass), instead of the original *UITableViewController*
    1. in *YourTableViewController.h*
        1. \#import "PPPullToRefreshTableViewController.h"
        2. @interface YourTableViewController : PPPullToRefreshTableViewController
    2. override the following method:
        1. *- (void) refreshing*
            - you should call *didRefresh* inside this method in order to hide the refresh header view
    3. you may want to call *willRefresh* to start refreshing in code (this method by default shows the refresh header view, and calls *refreshing* automatically)

3. In your build target's **Link Binbary with Libraries** section, add the *QuartzCore.framework*

You may clone the demo project, which is a Master-Detail application together with the *PPPullToRefreshTableViewController* source code, from here:

    git://github.com/peterwongpp/PPPullToRefreshTableViewController.git

The project's repository: [PPPullToRefreshTableViewController](http://github.com/peterwongpp/PPPullToRefreshTableViewController)

Any pull requests, discussions or issues are welcome!
