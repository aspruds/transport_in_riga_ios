//
//  RouteMapController.h
//  PublicTransport
//
//  Created by Andris Spruds on 4/4/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Route.h"
#import "StopSchedulesViewController.h"

@interface RouteMapController : UIViewController<MKMapViewDelegate> {
	MKMapView* mapView;
	Route* route;
	StopSchedulesViewController *stopSchedulesView;
}

@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) Route* route;
@property (nonatomic, retain) NSMutableArray* annotations;
@property (nonatomic, retain) StopSchedulesViewController* stopSchedulesView;

- (void)zoomToFitMapAnnotations;
@end
