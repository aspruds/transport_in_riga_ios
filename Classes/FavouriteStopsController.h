//
//  FavouriteStopsController.h
//  PublicTransport
//
//  Created by Andris Spruds on 4/18/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopPinAnnotation.h"
#import "StopSchedulesViewController.h"
#import "MBProgressHUD.h"

@interface FavouriteStopsController : UITableViewController {
	UITableViewCell* tableCell;
	UIView* tableHeader;
}

@property (nonatomic, retain) NSArray* stops;
@property (nonatomic, retain) IBOutlet UITableViewCell* tableCell;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic, retain) StopSchedulesViewController* stopSchedulesView;
@property (nonatomic, retain) MBProgressHUD* hud;

- (void) loadFavouriteStops;
- (void) updateTable;

@end
