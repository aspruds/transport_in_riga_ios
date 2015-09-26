//
//  ScheduleData.m
//  PublicTransport
//
//  Created by Andris Spruds on 12/11/11.
//  Copyright 2011 none. All rights reserved.
//

#import "ScheduleData.h"


@implementation ScheduleData

@synthesize stops;
@synthesize routes;

- (id)init:r stops:(NSString*)s {
	self.routes=r;
	self.stops=s;
	return self;
}

-(void)dealloc {
	[stops release];
	[routes release];
	[super dealloc];
}
@end
