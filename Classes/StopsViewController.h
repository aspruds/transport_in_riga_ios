//
//  StopsViewController.h
//  PublicTransport
//
//  Created by Andris Spruds on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopSchedulesViewController.h"
#import "Route.h"
#import "StopMapController.h"
#import "MBProgressHUD.h"

@interface StopsViewController : UITableViewController {
	UITableViewCell* tableCell;
	UIView* tableHeader;
	Route* route;
}

@property (nonatomic, retain) NSArray* stops;
@property (nonatomic, retain) IBOutlet UITableViewCell* tableCell;
@property (nonatomic, retain) StopSchedulesViewController* stopSchedulesView;
@property (nonatomic, retain) StopMapController* stopMapController;
@property (nonatomic, retain) IBOutlet UIView *tableHeader;
@property (nonatomic, retain) Route* route;
@property (nonatomic, retain) MBProgressHUD* hud;

- (void)updateHeader;
- (void) loadStops;
- (void) updateTable;
- (IBAction)mapButtonPressed:(id)sender;
- (void) onAddToFavouritesPressed:(UIBarButtonItem*)sender;

@end
