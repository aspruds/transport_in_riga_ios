//
//  PublicTransportViewController.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TransportTypesViewController.h"
#import "TransportType.h"

@implementation TransportTypesViewController

@synthesize routesView;

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
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.routesView = nil;
}

- (IBAction)buttonPressed:(UIButton*)sender {
	int tag = sender.tag;
	
	if(self.routesView == nil) {
		RoutesViewController *aRoutesView = [[RoutesViewController alloc] initWithNibName: @"RoutesView" bundle:nil];
		self.routesView = aRoutesView;
		[aRoutesView release];
	}
	
	if(tag == 0) {
		routesView.transportType = [TransportType transportTypeById:kBus];
	}
	else if(tag == 1) {
		routesView.transportType = [TransportType transportTypeById:kTram];
	}
	else if(tag == 2) {
		routesView.transportType = [TransportType transportTypeById:kTrolleybus];
	}
	
	[self.navigationController pushViewController:self.routesView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	self.title = NSLocalizedString(@"Home", @"Tab title");
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[super viewWillAppear:animated];
}


- (void)dealloc {
	[routesView release];
    [super dealloc];
}

@end
