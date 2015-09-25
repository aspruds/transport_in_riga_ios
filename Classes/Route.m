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
@synthesize number;
@synthesize title;
@synthesize lowfloor;
@synthesize transportType;

- (id)initWithTitle:(NSNumber*)rid number:(NSString*)n title:(NSString*)ttl 
		   lowfloor:(NSNumber*)lf transportType:(TransportType*)typ {
	
	self.routeId = rid;
	self.number = n;
	self.title = ttl;
	self.lowfloor = lf;
	self.transportType = typ;
	return self;
}

- (void)dealloc {
	[routeId release];
	[number release];
	[title release];
	[lowfloor release];
	[transportType release];
	[super dealloc];
}
@end
