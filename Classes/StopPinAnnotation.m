//
//  StopPinLocation.m
//  PublicTransport
//
//  Created by Andris Spruds on 12/31/11.
//  Copyright 2011 none. All rights reserved.
//

#import "StopPinAnnotation.h"

@implementation StopPinAnnotation

@synthesize stop;

-(id) initWithStop:(Stop*)s {
	self.stop = s;
	return self;
}

- (NSString*)title {
	return stop.name;
}

- (NSString*)subtitle {
	return stop.route.name;
}

- (CLLocationCoordinate2D)coordinate {	
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [stop.latitude floatValue] * 1e-5;
	coordinate.longitude = [stop.longitude floatValue] * 1e-5;
	
	return coordinate;
}

- (void)dealloc {
	[stop release];
	[super dealloc];
}
@end
