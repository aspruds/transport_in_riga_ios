//
//  Direction.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import "Direction.h"

@implementation Direction

@synthesize directionId;
@synthesize type;
@synthesize name;
@synthesize route;

- (id)initWithName:(NSNumber*)did type:(NSString*)t name:(NSString*)n route:(Route*)r {
	self.directionId = did;
	self.type = t;
	self.name = n;
	self.route = r;
	return self;
}

- (void)dealloc {
	[directionId release];
	[type release];
	[name release];
	[route release];
	[super dealloc];
}
@end
