//
//  StopsViewController.m
//  PublicTransport
//
//  Created by Andris Spruds on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "StopsViewController.h"
#import "Stop.h"
#import "DatabaseManager.h"


@implementation StopsViewController

@synthesize tableCell;
@synthesize stops;
@synthesize stopSchedulesView;
@synthesize tableHeader;
@synthesize direction;
@synthesize stopMapController;

static const int kYes = 0;

static const int kStopNameLabelTag = 1;
static const int kStopMapButtonTag = 2;

static const int kHeaderHeight = 28;
static const int kHeaderTransportTypeTag = 1;
static const int kHeaderDirectionTag = 2;

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
	[self setTitle:NSLocalizedString(@"Stops", @"View title")];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	DatabaseManager* db = [[DatabaseManager alloc] init];
	[db open];
	self.stops = [db getStopsByDirection:direction];
	[db close];
	[db release];
	
	[self.tableView reloadData];
	
	UIBarButtonItem* addToFavsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(onAddToFavouritesPressed:)];
	self.navigationItem.rightBarButtonItem = addToFavsButton;
	[addToFavsButton release];
	
	if(tableHeader != nil) {
		[self updateHeader];
	}
	[super viewWillAppear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)mapButtonPressed:(id)sender {
	UIButton* senderButton = (UIButton*)sender;
	Stop* stop = [self.stops objectAtIndex:senderButton.tag];
	
	if(stopMapController == nil) {
		StopMapController *aStopMapController = [[StopMapController alloc] initWithNibName:@"StopMapView" bundle:nil];
		self.stopMapController = aStopMapController;
		[aStopMapController release];
	}
	
	stopMapController.stop = stop;
	
	[self.navigationController pushViewController:stopMapController animated:YES];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [stops count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
		cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	static NSString* cellIdentifier = @"StopsCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if(cell == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"StopsViewCell" owner:self options:nil];
		if([nib count] > 0) {
			cell = self.tableCell;
		}
		else {
			NSLog(@"Failed to load StopsViewCell");
		}
	}
	
	NSUInteger row = [indexPath row];
	Stop* stop = [self.stops objectAtIndex:row];
	
	UILabel* stopNameLabel = (UILabel*)[cell viewWithTag:kStopNameLabelTag];
	stopNameLabel.text = stop.name;
	
	UIButton* mapViewButton = (UIButton*)[cell viewWithTag:kStopMapButtonTag];
	mapViewButton.tag = row;
	
	return cell;
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
	
    [self.navigationController pushViewController:stopSchedulesView animated:YES];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	if(tableHeader == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"StopsViewHeader" owner:self options:nil];
		if([nib count] < 1) {
			NSLog(@"Failed to load StopsViewHeader");
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) updateHeader {	
	UILabel* transportTypeLabel = (UILabel*)[tableHeader viewWithTag:kHeaderTransportTypeTag];
	transportTypeLabel.text = 
	[[direction.route.transportType.title stringByAppendingString:@" "]
	 stringByAppendingString:direction.route.number];
	
	NSString* directionName = nil;
	NSArray* components = [direction.name componentsSeparatedByString:@"-"];
	if([components count] < 2) {
		directionName = direction.name;
	}
	else {
		directionName = [components objectAtIndex:1];
	}
	
	UILabel* directionLabel = (UILabel*)[tableHeader viewWithTag:kHeaderDirectionTag];
	directionLabel.text = directionName;
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
		[db addRouteToFavourites:direction.route];
		[db close];
		[db release];
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.stops = nil;
	self.tableCell = nil;
	self.stopSchedulesView = nil;
	self.tableHeader = nil;
	self.direction = nil;
	self.stopMapController = nil;
}

- (void)dealloc {
	[super dealloc];
	[stops release];
	[tableCell release];
	[stopSchedulesView release];
	[tableHeader release];
	[direction release];
	[stopMapController release];
}


@end
