//
//  RouteMapController.m
//  PublicTransport
//
//  Created by Andris Spruds on 4/4/11.
//  Copyright 2011 none. All rights reserved.
//

#import "RouteMapController.h"
#import "MapKit/MapKit.h"
#import "RouteService.h"
#import "Stop.h"
#import "StopPinAnnotation.h"

@implementation RouteMapController

@synthesize mapView;
@synthesize route;
@synthesize annotations;
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
	
	CGRect bounds = self.view.bounds;
	CGRect mapSize = CGRectMake(bounds.origin.x, 
								bounds.origin.y,
								bounds.size.width,
								bounds.size.height - 44);
								
	mapView = [[MKMapView alloc] initWithFrame:mapSize];
	
	mapView.delegate = self;
	mapView.showsUserLocation = NO;
	[self.view insertSubview:mapView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
	[self setTitle:NSLocalizedString(@"Map", "View title")];
	
	if(annotations != nil) {
		[mapView removeAnnotations:annotations];
		[annotations release];
		annotations = nil;
	}
	annotations = [[NSMutableArray alloc] init];
	
	RouteService* routeService = [RouteService getInstance];
	NSArray* stops = [routeService getStopsByRoute:route];
	for(Stop* stop in stops) {
		StopPinAnnotation* pin = [[StopPinAnnotation alloc] initWithStop:stop];
		[annotations addObject:pin];
		[pin release];
	}
	[mapView addAnnotations:annotations];
	[self zoomToFitMapAnnotations];
	
	[super viewWillAppear:animated];
}

- (void)mapView:(MKMapView*)mapView annotationView:(MKAnnotationView*)annotationView
calloutAccessoryControlTapped:(UIControl*)control {
	
	if(stopSchedulesView == nil) {
		StopSchedulesViewController *aStopSchedulesView = [[StopSchedulesViewController alloc] 
														   initWithNibName:@"StopSchedulesView" bundle:nil];
		
		self.stopSchedulesView = aStopSchedulesView;
		[aStopSchedulesView release];
	}
	
	StopPinAnnotation* pin = (StopPinAnnotation*) annotationView.annotation;
	stopSchedulesView.stop = [pin stop];
	
    [self.navigationController pushViewController:stopSchedulesView animated:YES];
}

- (void)zoomToFitMapAnnotations { 
	MKMapRect zoomRect = MKMapRectNull;
	for (id <MKAnnotation> annotation in mapView.annotations)
	{
		MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
		MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
		if (MKMapRectIsNull(zoomRect)) {
			zoomRect = pointRect;
		} else {
			zoomRect = MKMapRectUnion(zoomRect, pointRect);
		}
	}
	[mapView setVisibleMapRect:zoomRect animated:YES];
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
	self.mapView = nil;
	self.route = nil;
	self.annotations = nil;
	self.stopSchedulesView = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[mapView release];
	[route release];
	[annotations release];
	[stopSchedulesView release];
	[super dealloc];
}


@end
