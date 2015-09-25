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

@interface StopMapController : UIViewController {
	MKMapView* mapView;
	Stop* stop;
}

@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) Stop* stop;

@end
