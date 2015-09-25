//
//  TransportType.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import "TransportType.h"

@implementation TransportType

@synthesize transportTypeId;
@synthesize title;

- (id)initWithTitle:(NSNumber*)ttid title:(NSString*)t {
	self.transportTypeId = ttid;
	self.title = t;
	return self;
}

+ (TransportType*)transportTypeById:(int)typeId {
	TransportType* transportType = nil;
	switch (typeId) {
		case 0:
			transportType = [[TransportType alloc] initWithTitle:[NSNumber numberWithInt:kBus]
				title:NSLocalizedString(@"Bus", @"Routes View title")];
			break;
		case 1:
			transportType = [[TransportType alloc] initWithTitle:[NSNumber numberWithInt:kTram]
				title:NSLocalizedString(@"Tram", @"Routes View title")];
			break;
		case 2:
			transportType = [[TransportType alloc] initWithTitle:[NSNumber numberWithInt:kTrolleybus]
				title:NSLocalizedString(@"Trolleybus", @"Routes View title")];
			break;
		default:
			break;
	}
	return [transportType autorelease];
}

-(void)dealloc {
	[transportTypeId release];
	[title release];
	[super dealloc];
}
@end
