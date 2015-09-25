//
//  DirectionsViewController.m
//  PublicTransport
//
//  Created by Andris Spruds on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "DirectionsViewController.h"
#import "Direction.h"
#import "DatabaseManager.h"
#import "RouteMapController.h"

@implementation DirectionsViewController

@synthesize tableCell;
@synthesize tableHeader;
@synthesize directions;
@synthesize stopsView;
@synthesize routeMapController;
@synthesize route;

static const int kYes = 0;

static const int kDirectionNameLabelTag = 1;
static const int kDirectionMapButtonTag = 2;

static const int kHeaderHeight = 28;
static const int kHeaderTransportTypeTag = 1;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self setTitle:NSLocalizedString(@"Directions", @"View title")];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	DatabaseManager* db = [[DatabaseManager alloc] init];
	[db open];
	self.directions = [db getDirectionsByRoute:route];
	[db close];
	[db release];
	
	[self.tableView reloadData];
	
	if(tableHeader != nil) {
		[self updateHeader];
	}
	
	UIBarButtonItem* addToFavsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(onAddToFavouritesPressed:)];
	self.navigationItem.rightBarButtonItem = addToFavsButton;
	[addToFavsButton release];
	
	[super viewWillAppear:animated];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [directions count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
		cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	static NSString* cellIdentifier = @"DirectionsCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if(cell == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"DirectionsViewCell" owner:self options:nil];
		if([nib count] > 0) {
			cell = self.tableCell;
		}
		else {
			NSLog(@"Failed to load DirectionsViewCell");
		}
	}
	
	NSUInteger row = [indexPath row];
	Direction* direction = [self.directions objectAtIndex:row];
	
	UILabel* directionNameLabel = (UILabel*)[cell viewWithTag:kDirectionNameLabelTag];
	directionNameLabel.text = direction.name;
	
	UIButton* mapViewButton = (UIButton*)[cell viewWithTag:kDirectionMapButtonTag];
	mapViewButton.tag = row;
	
	return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	if(stopsView == nil) {
		StopsViewController *aStopsView = [[StopsViewController alloc] initWithNibName:@"StopsView" bundle:nil];
		self.stopsView = aStopsView;
		[aStopsView release];
	}
	
	NSUInteger row = [indexPath row];
	Direction* direction = [self.directions objectAtIndex:row];
	stopsView.direction = direction;
	
    [self.navigationController pushViewController:stopsView animated:YES];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	if(tableHeader == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"DirectionsViewHeader" owner:self options:nil];
		if([nib count] < 1) {
			NSLog(@"Failed to load DirectionsViewHeader");
		}
		else {
			[self updateHeader];
		}
	}
	return tableHeader;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
	return kHeaderHeight;
}

-(void)updateHeader {
	UILabel* transportTypeLabel = (UILabel*)[tableHeader viewWithTag:kHeaderTransportTypeTag];
	transportTypeLabel.text = 
	[[route.transportType.title stringByAppendingString:@" "]
	 stringByAppendingString:route.number];
}

-(IBAction)mapButtonPressed:(id)sender {
	UIButton* senderButton = (UIButton*)sender;
	Direction* direction = [self.directions objectAtIndex:senderButton.tag];
	
	if(routeMapController == nil) {
		RouteMapController *aRouteMapController = [[RouteMapController alloc] initWithNibName:@"RouteMapView" bundle:nil];
		self.routeMapController = aRouteMapController;
		[aRouteMapController release];
	}

	routeMapController.direction = direction;
	
	[self.navigationController pushViewController:routeMapController animated:YES];
}

-(void) onAddToFavouritesPressed:(UIBarButtonItem*)sender {
	UIAlertView* alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Confirm"];
	[alert setMessage:@"Add to favourites?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
	[alert release];
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == kYes) {
		DatabaseManager* db = [[DatabaseManager alloc] init];
		[db open];
		[db addRouteToFavourites:route];
		[db close];
		[db release];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.tableCell = nil;
	self.tableHeader = nil;
	self.directions = nil;
	self.stopsView = nil;
	self.routeMapController = nil;
	self.route = nil;
}


- (void)dealloc {
	[tableCell release];
	[tableHeader release];
	[directions release];
	[stopsView release];
	[routeMapController release];
	[route release];
    [super dealloc];
}

@end
