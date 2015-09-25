//
//  RoutesController.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectionsViewController.h"
#import "TransportType.h"
#import "DatabaseManager.h"

@interface RoutesViewController : UITableViewController {
	UITableViewCell *tableCell;
	UIView *tableHeader;
	TransportType* transportType;
}

@property (nonatomic, retain) TransportType* transportType;
@property (nonatomic, retain) IBOutlet UITableViewCell *tableCell;
@property (nonatomic, retain) IBOutlet UIView *tableHeader;
@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) DirectionsViewController *directionsView;

-(void) updateHeader;

@end

