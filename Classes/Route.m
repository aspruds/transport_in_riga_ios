//
//  Route.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import "Route.h"


@implementation Route

@synthesize routeId;
@synthesize authority;
@synthesize city;
@synthesize transportType;
@synthesize operator;
@synthesize specialDates;
@synthesize weekdays;
@synthesize validityPeriods;
@synthesize number;
@synthesize name;
@synthesize directionType;
@synthesize routeTag;
@synthesize stops;
@synthesize times;
@synthesize commercial;
@synthesize order;

-(NSString*) description {
	return [NSString stringWithFormat:@"Route (routeId=%@, number=%@, city=%@, transportType=%@)", 
			routeId, number, city, transportType ];
}

- (void)dealloc {	
	[routeId release];
	[authority release];
	[city release];
	[transportType release];
	[operator release];
	[specialDates release];
	[weekdays release];
	[validityPeriods release];
	[number release];
	[name release];
	[directionType release];
	[routeTag release];
	[stops release];
	[times release];
	[commercial release];
	[order release];
	
	[super dealloc];
}
@end
