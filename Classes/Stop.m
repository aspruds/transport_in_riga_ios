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
@synthesize name;
@synthesize longitude;
@synthesize latitude;
@synthesize direction;

- (id)initWithName:sid name:(NSString*)n latitude:(NSNumber*)lat longitude:(NSNumber*)lon {
	self.stopId = sid;
	self.name = n;
	self.latitude = lat;
	self.longitude = lon;
	return self;
}

- (void)dealloc {
	[stopId release];
	[name release];
	[longitude release];
	[latitude release];
	[super dealloc];
}

@end
