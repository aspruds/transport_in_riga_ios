//
//  PublicTransportViewController.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TransportTypesViewController.h"
#import "TransportType.h"
#import "RoutesViewController.h"
#import "MBProgressHUD.h"

@implementation TransportTypesViewController

@synthesize routesView;
@synthesize tableCell;
@synthesize tableHeader;
@synthesize transportTypes;
@synthesize hud;

static const int kHeaderHeight = 28;
static const int kHeaderTransportTypeTag = 1;
static const int kTransportTypeImageTag = 1;
static const int kTransportTypeTitleLabelTag = 2;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[[self navigationController] setNavigationBarHidden:YES animated:NO];
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self setTitle:NSLocalizedString(@"Transport Types", @"Tab title")];
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void) loadTransportTypes {
	RouteService* routeService = [RouteService getInstance];
	self.transportTypes = [[routeService getTransportTypes] retain];
	
	[self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:NO];
}

-(void) updateTable {
	[self.tableView reloadData];
	[self updateHeader];
}

- (void)viewWillAppear:(BOOL)animated {
	hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:hud];
	hud.labelText = NSLocalizedString(@"Loading...", @"Progress bar text");	
	[hud showWhileExecuting:@selector(loadTransportTypes) onTarget:self withObject:nil animated:YES];
	
	//[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[[self navigationController] setTitle:NSLocalizedString(@"Home", @"Tab title")];
	[super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [transportTypes count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
		cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	static NSString* cellIdentifier = @"TransportTypesCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if(cell == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"TransportTypesViewCell" owner:self options:nil];
		if([nib count] > 0) {
			cell = self.tableCell;
		}
		else {
			NSLog(@"Failed to load TransportTypesViewCell");
		}
	}
	
	NSUInteger row = [indexPath row];
	TransportType* transportType = [self.transportTypes objectAtIndex:row];
	
	UIImageView* transportTypeImage = (UIImageView*)[cell viewWithTag:kTransportTypeImageTag];
	transportTypeImage.image = [UIImage imageNamed:transportType.iconName];
	
	UILabel* transportTypeTitleLabel = (UILabel*)[cell viewWithTag:kTransportTypeTitleLabelTag];
	transportTypeTitleLabel.text = transportType.title;
	
	return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	if(routesView == nil) {		
		routesView = [[RoutesViewController alloc] initWithNibName:@"RoutesView" bundle:nil];
	}
	
	NSUInteger row = [indexPath row];
	TransportType* transportType = [self.transportTypes objectAtIndex:row];
	routesView.transportType = transportType;
	
    [self.navigationController pushViewController:routesView animated:YES];
}

/*
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	if(tableHeader == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"TransportTypesViewHeader" owner:self options:nil];
		if([nib count] < 1) {
			NSLog(@"Failed to load TransportTypesViewHeader");
		}
		else {
			[self updateHeader];
		}
	}
	return tableHeader;
}
*/

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
	return kHeaderHeight;
}

-(void)updateHeader {
	UILabel* transportTypeLabel = (UILabel*)[tableHeader viewWithTag:kHeaderTransportTypeTag];
	transportTypeLabel.text = NSLocalizedString(@"Transport Types", @"Header Title");
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.routesView = nil;
	self.tableHeader = nil;
	self.tableCell = nil;
	self.transportTypes = nil;
}

- (void)dealloc {
	[routesView release];
	[tableHeader release];
	[tableCell release];
	[transportTypes release];
	[hud release];
    [super dealloc];
}

@end
