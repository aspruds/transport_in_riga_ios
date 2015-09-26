//
//  DirectionsViewController.h
//  PublicTransport
//
//  Created by Andris Spruds on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopsViewController.h"
#import "RouteMapController.h"
#import "Route.h"
#import "MBProgressHUD.h"

@interface DirectionsViewController : UITableViewController {
	UITableViewCell* tableCell;
	UIView* tableHeader;
	Route* route;
}

@property (nonatomic, retain) NSArray* directions;
@property (nonatomic, retain) IBOutlet UITableViewCell* tableCell;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic, retain) StopsViewController* stopsView;
@property (nonatomic, retain) RouteMapController* routeMapController;
@property (nonatomic, retain) Route* route;
@property (nonatomic, retain) MBProgressHUD* hud;

-(void)updateHeader;
-(void) loadDirections;
-(void) updateTable;
-(IBAction)mapButtonPressed:(id)sender;
-(void) onAddToFavouritesPressed:(UIBarButtonItem*)sender;

@end
