//
//  Stop.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import "Stop.h"


@implementation Stop

@synthesize stopId;
@synthesize longitude;
@synthesize latitude;
@synthesize stopsNearby;
@synthesize name;
@synthesize info;
@synthesize street;
@synthesize area;
@synthesize city;
@synthesize route;

- (NSUInteger) hash {
	NSUInteger prime = 31;
	NSUInteger result = 1;
	
	return prime * result + [stopId intValue];
}

-(BOOL) isEqual:(id)other {
	if(other == self) {
		return YES;
	}
	if(!other || ![other isKindOfClass:[self class]]) {
		return NO;
	}
	
	Stop* otherStop = other;
	return [stopId isEqual:otherStop.stopId];
}

- (void)dealloc {
	[stopId release];
	[longitude release];
	[latitude release];
	[stopsNearby release];
	[name release];
	[info release];
	[street release];
	[area release];
	[city release];
	[route release];
	[super dealloc];
}

@end
