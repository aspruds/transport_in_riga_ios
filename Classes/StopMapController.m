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
@synthesize stopAnnotation;
@synthesize stopSchedulesView;

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
	
	// add map view
	CGRect bounds = self.view.bounds;
	CGRect mapSize = CGRectMake(bounds.origin.x, 
								bounds.origin.y,
								bounds.size.width,
								bounds.size.height - 44);
	
	mapView = [[MKMapView alloc] initWithFrame:mapSize];
	
	mapView.showsUserLocation = YES;
	mapView.delegate = self;
	[self.view insertSubview:mapView atIndex:0];
}

- (MKAnnotationView*) mapView:(MKMapView*)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	MKPinAnnotationView* annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation 
		reuseIdentifier:@"stopLocation"];
	
	UIButton* disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	 
	annotationView.pinColor = MKPinAnnotationColorGreen;
	annotationView.canShowCallout = YES;
	annotationView.animatesDrop = YES;
	annotationView.rightCalloutAccessoryView = disclosureButton;
	
	return [annotationView autorelease];
}

- (void)mapView:(MKMapView*)mapView annotationView:(MKAnnotationView*)annotationView
calloutAccessoryControlTapped:(UIControl*)control {
	
	if(stopSchedulesView == nil) {
		StopSchedulesViewController *aStopSchedulesView = [[StopSchedulesViewController alloc] 
														   initWithNibName:@"StopSchedulesView" bundle:nil];
		
		self.stopSchedulesView = aStopSchedulesView;
		[aStopSchedulesView release];
	}
	stopSchedulesView.stop = stop;
	
    [self.navigationController pushViewController:stopSchedulesView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[self setTitle:NSLocalizedString(@"Map", "View title")];	
	
	// add annotation
	if(stopAnnotation != nil) {
		[mapView removeAnnotation:stopAnnotation];
		[stopAnnotation release];
		stopAnnotation = nil;
	}
	stopAnnotation = [[StopPinAnnotation alloc] initWithStop:stop];
	[mapView addAnnotation:stopAnnotation];
	// [mapView selectAnnotation:stopAnnotation animated:YES];
	
	// center map
	MKCoordinateSpan span;
	span.latitudeDelta = 0.1;
	span.longitudeDelta = 0.1;
	
	MKCoordinateRegion region;
	region.span = span;
	region.center = stopAnnotation.coordinate;
	
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
	[super viewWillAppear:animated];
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
	self.stopAnnotation = nil;
	self.stopSchedulesView = nil;
}


- (void)dealloc {
    [super dealloc];
	[mapView release];
	[stop release];
	[stopAnnotation release];
	[stopSchedulesView release];
}


@end
