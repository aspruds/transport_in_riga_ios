//
//  StopsViewController.h
//  PublicTransport
//
//  Created by Andris Spruds on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopSchedulesViewController.h"
#import "Direction.h"
#import "StopMapController.h"

@interface StopsViewController : UITableViewController {
	UITableViewCell* tableCell;
	UIView* tableHeader;
	Direction* direction;
}

@property (nonatomic, retain) NSArray* stops;
@property (nonatomic, retain) IBOutlet UITableViewCell* tableCell;
@property (nonatomic, retain) StopSchedulesViewController* stopSchedulesView;
@property (nonatomic, retain) StopMapController* stopMapController;
@property (nonatomic, retain) IBOutlet UIView *tableHeader;
@property (nonatomic, retain) Direction* direction;

-(void)updateHeader;
-(IBAction)mapButtonPressed:(id)sender;
-(void) onAddToFavouritesPressed:(UIBarButtonItem*)sender;

@end
