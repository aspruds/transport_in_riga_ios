//
//  RoutesController.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "RoutesViewController.h"
#import "Route.h"


@implementation RoutesViewController

@synthesize transportType;
@synthesize tableCell;
@synthesize routes;
@synthesize directionsView;
@synthesize tableHeader;

static const int kHeaderHeight = 28;
static const int kHeaderTransportTypeTag = 1;

static const int kRouteNumberLabelTag = 1;
static const int kRouteTitleLabelTag = 2;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    [super viewDidLoad];
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
	return [routes count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
		cellForRowAtIndexPath:(NSIndexPath*)indexPath {
			
	static NSString* cellIdentifier = @"RoutesCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if(cell == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"RoutesViewCell" owner:self options:nil];
		if([nib count] > 0) {
			cell = self.tableCell;
		}
		else {
			NSLog(@"Failed to load RoutesViewCell");
		}
	}
	
	NSUInteger row = [indexPath row];
	Route* route = [self.routes objectAtIndex:row];
	
	UILabel* routeNumberLabel = (UILabel*)[cell viewWithTag:kRouteNumberLabelTag];
	routeNumberLabel.text = route.number;
	 		   
	UILabel* routeTitleLabel = (UILabel*)[cell viewWithTag:kRouteTitleLabelTag];
	routeTitleLabel.text = route.title;

	return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	if(directionsView == nil) {		
		DirectionsViewController *aDirectionsView = [[DirectionsViewController alloc] initWithNibName:@"DirectionsView" bundle:nil];
		self.directionsView = aDirectionsView;
		[aDirectionsView release];
	}
	
	NSUInteger row = [indexPath row];
	Route* route = [self.routes objectAtIndex:row];
	route.transportType = transportType;
	directionsView.route = route;
	
    [self.navigationController pushViewController:directionsView animated:YES];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	if(tableHeader == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"RoutesViewHeader" owner:self options:nil];
		if([nib count] < 1) {
			NSLog(@"Failed to load RoutesViewHeader");
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

- (void)updateHeader {
	UILabel* transportTypeLabel = (UILabel*)[tableHeader viewWithTag:kHeaderTransportTypeTag];
	transportTypeLabel.text = transportType.title;
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
	self.routes = nil;
	self.directionsView = nil;
	self.tableHeader = nil;
	self.transportType = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	
	DatabaseManager* db = [[DatabaseManager alloc] init];
	[db open];
	self.routes = [db getRoutesByTransportType:transportType];
	[db close];
	[db release];
	
	[self.tableView reloadData];
	
	//[self setTitle:transportType.title];
	[self setTitle:NSLocalizedString(@"Routes", @"View title")];	
	
	if(tableHeader != nil) {
		[self updateHeader];
	}
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
	[super viewWillAppear:animated];
}

- (void)dealloc {
	[routes release];
	[tableCell release];
	[tableHeader release];
	[directionsView release];
	[transportType release];
    [super dealloc];
}


@end
