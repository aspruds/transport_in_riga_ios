//
//  StopSchedule.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import "StopSchedule.h"


@implementation StopSchedule

@synthesize stopScheduleId;
@synthesize timingId;
@synthesize hours;
@synthesize minutes;
@synthesize daysValid;
@synthesize lowfloor;
@synthesize shortened;

- (id)init:sid timingId:(NSNumber*)tid hours:(NSNumber*)hrs 
		   minutes:(NSNumber*)mins daysValid:(NSNumber*)valid lowfloor:(NSNumber*)isLow shortened:(NSNumber*)isShort {
	
	self.stopScheduleId = sid;
	self.timingId = tid;
	self.hours = hrs;
	self.minutes = mins;
	self.daysValid = valid;
	self.lowfloor = isLow;
	self.shortened = isShort;
	
	return self;
}

- (void)dealloc {
	[stopScheduleId release];
	[timingId release];
	[hours release];
	[minutes release];
	[daysValid release];
	[lowfloor release];
	[shortened release];
	[super dealloc];
}
@end
