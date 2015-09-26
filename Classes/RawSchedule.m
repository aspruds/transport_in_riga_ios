//
//  RawSchedule.m
//  PublicTransport
//
//  Created by Andris Spruds on 12/11/11.
//  Copyright 2011 none. All rights reserved.
//

#import "RawSchedule.h"


@implementation RawSchedule

@synthesize times;
@synthesize timesSize;
@synthesize tags;
@synthesize tagsSize;
@synthesize validFrom;
@synthesize validTo;
@synthesize workdays;

-(void)dealloc {
	free(times);
	free(tags);
	free(validFrom);
	free(validTo);
	free(workdays);
	[super dealloc];
}
@end