//
//  FavouriteRoutesController.m
//  PublicTransport
//
//  Created by Andris Spruds on 4/18/11.
//  Copyright 2011 none. All rights reserved.
//

#import "FavouriteRoutesController.h"
#import "Route.h"
#import "DatabaseManager.h"
#import "PreferencesService.h"
#import "City.h"
#import "PublicTransportAppDelegate.h"

@implementation FavouriteRoutesController

@synthesize routes;
@synthesize tableCell;
@synthesize tableHeader;
@synthesize directionsView;
@synthesize hud;

static const int kHeaderHeight = 28;

static const int kRouteNumberLabelTag = 1;
static const int kRouteTransportTypeImageTag = 2;
static const int kRouteTitleLabelTag = 3;

- (void)viewWillAppear:(BOOL)animated {
	hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	hud.labelText = NSLocalizedString(@"Loading...", @"Progress bar text");	
	[hud showWhileExecuting:@selector(loadFavouriteRoutes) onTarget:self withObject:nil animated:YES];
	
	[super viewWillAppear:animated];
}

- (void) loadFavouriteRoutes {
	City*city = [PreferencesService getCurrentCity];
	
	DatabaseManager* db = [[DatabaseManager alloc] init];
	[db open];
	self.routes = [[db getFavouriteRoutes:city] retain];
	[db close];
	[db release];
	
	[self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:NO];
}

- (void) updateTable {
	[self.tableView reloadData];	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	if(tableHeader == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"FavouriteRoutesViewHeader" owner:self options:nil];
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
	return [routes count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
		cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	static NSString* cellIdentifier = @"FavouriteRoutesCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if(cell == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"FavouriteRoutesViewCell" owner:self options:nil];
		if([nib count] > 0) {
			cell = self.tableCell;
		}
		else {
			NSLog(@"Failed to load FavouriteRoutesViewCell");
		}
	}
	
	NSUInteger row = [indexPath row];
	Route* route = [self.routes objectAtIndex:row];
	
	UILabel* routeNumberLabel = (UILabel*)[cell viewWithTag:kRouteNumberLabelTag];
	routeNumberLabel.text = route.number;
	
	UIImageView* routeTransportTypeImage = (UIImageView*)[cell viewWithTag:kRouteTransportTypeImageTag];
	routeTransportTypeImage.image = [UIImage imageNamed:route.transportType.iconName];
	
	UILabel* routeTitleLabel = (UILabel*)[cell viewWithTag:kRouteTitleLabelTag];
	routeTitleLabel.text = route.name;
	
	return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	if(directionsView == nil) {		
		directionsView = [[DirectionsViewController alloc] initWithNibName:@"DirectionsView" bundle:nil];
	}
	
	NSUInteger row = [indexPath row];
	Route* route = [self.routes objectAtIndex:row];
	directionsView.route = route;
	
	// show view
	PublicTransportAppDelegate* appDelegate = (PublicTransportAppDelegate*) [UIApplication sharedApplication].delegate;
	[appDelegate.favouritesNavigationController pushViewController:directionsView animated:NO];
}

- (void)tableView: (UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
	[tableView beginUpdates];
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		NSUInteger row = [indexPath row];
		Route* route = [routes objectAtIndex:row];
		
		City* city = [PreferencesService getCurrentCity];
		
		DatabaseManager* db = [[DatabaseManager alloc] init];
		[db open];
		[db deleteFavouriteRoute:city route:route];
		[db close];
		[db release];
		
		NSMutableArray* mutableRoutes = [NSMutableArray arrayWithArray:routes];
		[mutableRoutes removeObjectAtIndex:row];
		
		[routes release];
		routes = nil;
		routes = [mutableRoutes retain];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
	}
	[tableView endUpdates];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.tableCell = nil;
	self.tableHeader = nil;
	self.routes = nil;
	self.directionsView = nil;
	self.hud = nil;
}

- (void)dealloc {
	[tableCell release];
	[tableHeader release];
	[routes release];
	[directionsView release];
	[hud release];
	[super dealloc];
}


@end
