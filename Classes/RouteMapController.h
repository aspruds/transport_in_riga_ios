//
//  RouteMapController.h
//  PublicTransport
//
//  Created by Andris Spruds on 4/4/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Direction.h"

@interface RouteMapController : UIViewController {
	MKMapView* mapView;
	Direction* direction;
}

@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) Direction* direction;

@end
