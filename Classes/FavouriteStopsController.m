//
//  FavouriteStopsController.m
//  PublicTransport
//
//  Created by Andris Spruds on 4/18/11.
//  Copyright 2011 none. All rights reserved.
//

#import "FavouriteStopsController.h"
#import "DatabaseManager.h"
#import "Stop.h"
#import "City.h"
#import "PreferencesService.h"
#import "PublicTransportAppDelegate.h"

@implementation FavouriteStopsController

@synthesize stops;
@synthesize tableCell;
@synthesize tableHeader;
@synthesize stopSchedulesView;
@synthesize hud;

static const int kHeaderHeight = 28;

static const int kStopNumberLabelTag = 1;
static const int kStopTransportTypeImageTag = 2;
static const int kStopNameLabelTag = 3;
static const int kStopDirectionNameLabelTag = 4;

- (void)viewWillAppear:(BOOL)animated {
	hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	hud.labelText = NSLocalizedString(@"Loading...", @"Progress bar text");	
	[hud showWhileExecuting:@selector(loadFavouriteStops) onTarget:self withObject:nil animated:YES];

	[super viewWillAppear:animated];
}

- (void) loadFavouriteStops {
	City*city = [PreferencesService getCurrentCity];
	
	DatabaseManager* db = [[DatabaseManager alloc] init];
	[db open];
	self.stops = [[db getFavouriteStops:city] retain];
	[db close];
	[db release];
	
	[self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:NO];
}

- (void) updateTable {
	[self.tableView reloadData];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	if(tableHeader == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"FavouriteStopsViewHeader" owner:self options:nil];
		if([nib count] < 1) {
			NSLog(@"Failed to load FavouriteStopsViewHeader");
		}
	}
	return tableHeader;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
	return kHeaderHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [stops count];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	if(stopSchedulesView == nil) {
		StopSchedulesViewController *aStopSchedulesView = [[StopSchedulesViewController alloc] 
														   initWithNibName:@"StopSchedulesView" bundle:nil];
		
		self.stopSchedulesView = aStopSchedulesView;
		[aStopSchedulesView release];
	}
	
	NSUInteger row = [indexPath row];
	Stop* stop = [self.stops objectAtIndex:row];
	stopSchedulesView.stop = stop;
	
	// show view
	PublicTransportAppDelegate* appDelegate = (PublicTransportAppDelegate*) [UIApplication sharedApplication].delegate;
	[appDelegate.favouritesNavigationController pushViewController:stopSchedulesView animated:NO];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
		cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	static NSString* cellIdentifier = @"FavouriteStopsCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if(cell == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"FavouriteStopsViewCell" owner:self options:nil];
		if([nib count] > 0) {
			cell = self.tableCell;
		}
		else {
			NSLog(@"Failed to load FavouriteStopsViewCell");
		}
	}
	
	NSUInteger row = [indexPath row];
	Stop* stop = [self.stops objectAtIndex:row];
	
	UILabel* stopNumberLabel = (UILabel*)[cell viewWithTag:kStopNumberLabelTag];
	stopNumberLabel.text = stop.route.number;
	
	UIImageView* stopTransportTypeImage = (UIImageView*)[cell viewWithTag:kStopTransportTypeImageTag];
	stopTransportTypeImage.image = [UIImage imageNamed:stop.route.transportType.iconName];
	
	UILabel* stopNameLabel = (UILabel*)[cell viewWithTag:kStopNameLabelTag];
	stopNameLabel.text = stop.name;
	
	UILabel* stopDirectionNameLabel = (UILabel*)[cell viewWithTag:kStopDirectionNameLabelTag];
	stopDirectionNameLabel.text = stop.route.name;
	
	return cell;
}

- (void)tableView: (UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
	[tableView beginUpdates];
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		NSUInteger row = [indexPath row];
		Stop* stop = [self.stops objectAtIndex:row];
		
		City* city = [PreferencesService getCurrentCity];
		
		DatabaseManager* db = [[DatabaseManager alloc] init];
		[db open];
		[db deleteFavouriteStop:city stop:stop];
		[db close];
		[db release];
		
		NSMutableArray* mutableStops = [NSMutableArray arrayWithArray:stops];
		[mutableStops removeObjectAtIndex:row];
		
		[stops release];
		stops = nil;
		stops = [mutableStops retain];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
	}
	[tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.tableCell = nil;
	self.tableHeader = nil;
	self.stops = nil;
	self.stopSchedulesView = nil;
	self.hud = nil;
}


- (void)dealloc {
	[tableCell release];
	[tableHeader release];
	[stops release];
	[stopSchedulesView release];
	[hud release];
	[super dealloc];
}


@end
