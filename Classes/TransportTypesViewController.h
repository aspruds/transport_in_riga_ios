//
//  PublicTransportViewController.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteNavigationController.h"
#import "RoutesViewController.h"

@interface TransportTypesViewController : UITableViewController {
	UITableViewCell* tableCell;
	UIView* tableHeader;
}

@property (nonatomic, retain) RoutesViewController *routesView;
@property (nonatomic, retain) IBOutlet UITableViewCell* tableCell;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic, retain) NSArray* transportTypes;
@property (nonatomic, retain) MBProgressHUD* hud;

-(void) loadTransportTypes;
-(void) updateTable;
-(void) updateHeader;
@end

