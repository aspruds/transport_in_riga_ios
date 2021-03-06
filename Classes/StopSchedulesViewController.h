//
//  StopSchedulesViewController.h
//  PublicTransport
//
//  Created by Andris Spruds on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stop.h"

@interface StopSchedulesViewController : UITableViewController {
	UITableViewCell* tableCell;
	UIView* tableHeader;
	Stop* stop;
	UISegmentedControl* daySwitcher;
	int currentDayType;
	NSMutableSet* dayTypes;
	NSMutableArray* nextDepartures;
}

@property (nonatomic, retain) IBOutlet UITableViewCell* tableCell;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) IBOutlet UISegmentedControl* daySwitcher;
@property (nonatomic, retain) NSArray* stopSchedules;
@property (nonatomic, retain) NSDictionary* stopScheduleMap;
@property (nonatomic, retain) NSMutableSet* dayTypes;
@property (nonatomic, retain) NSMutableArray* nextDepartures;
@property int currentDayType;

- (void) updateHeader;
- (void) buildStopScheduleMap;
- (void) addDaySwitchers;
- (int) getDayByteValue;
- (void) calculateDayTypes;
- (void) calculateCurrentDayType;
- (void) calculateNextDepartures;
- (IBAction) dayTypeChanged:(id)sender;

- (void) onAddToFavouritesPressed:(UIBarButtonItem*)sender;

@end
