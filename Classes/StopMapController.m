//
//  StopMapController.m
//  PublicTransport
//
//  Created by Andris Spruds on 4/7/11.
//  Copyright 2011 none. All rights reserved.
//

#import "StopMapController.h"


@implementation StopMapController

@synthesize mapView;
@synthesize stop;

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
    [super viewDidLoad];
	mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	mapView.showsUserLocation = YES;
	[self.view insertSubview:mapView atIndex:0];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.mapView = nil;
	self.stop = nil;
}


- (void)dealloc {
    [super dealloc];
	[mapView release];
	[stop release];
}


@end
