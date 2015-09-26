//
//  StopSchedule.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import "StopSchedule.h"

@implementation StopSchedule

@synthesize stop;
@synthesize route;
@synthesize hours;
@synthesize minutes;
@synthesize daysValid;
@synthesize lowfloor;
@synthesize shortened;
@synthesize changed;

- (id)init:st route:(Route*)rt hours:(NSNumber*)hrs 
   minutes:(NSNumber*)mins daysValid:(NSNumber*)valid lowfloor:(NSNumber*)isLow shortened:(NSNumber*)isShort changed:(NSNumber*)isChanged {
	
	self.stop = st;
	self.route = rt;
	self.hours = hrs;
	self.minutes = mins;
	self.daysValid = valid;
	self.lowfloor = isLow;
	self.shortened = isShort;
	self.changed = isChanged;
	
	return self;
}

- (void)dealloc {
	[stop release];
	[route release];
	[hours release];
	[minutes release];
	[daysValid release];
	[lowfloor release];
	[shortened release];
	[changed release];
	[super dealloc];
}
@end
