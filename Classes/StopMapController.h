//
//  StopMapController.h
//  PublicTransport
//
//  Created by Andris Spruds on 4/7/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Stop.h"
#import "StopPinAnnotation.h"
#import "StopSchedulesViewController.h"

@interface StopMapController : UIViewController<MKMapViewDelegate> {
	MKMapView* mapView;
	Stop* stop;
}

@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) StopPinAnnotation* stopAnnotation;
@property (nonatomic, retain) StopSchedulesViewController* stopSchedulesView;
@end
