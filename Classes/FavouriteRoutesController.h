//
//  FavouriteRoutesController.h
//  PublicTransport
//
//  Created by Andris Spruds on 4/18/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectionsViewController.h"
#import "MBProgressHUD.h"

@interface FavouriteRoutesController : UITableViewController {
	UITableViewCell* tableCell;
	UIView* tableHeader;
}

@property (nonatomic, retain) NSArray* routes;
@property (nonatomic, retain) IBOutlet UITableViewCell* tableCell;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic, retain) DirectionsViewController* directionsView;
@property (nonatomic, retain) MBProgressHUD* hud;

- (void) loadFavouriteRoutes;
- (void) updateTable;
@end
