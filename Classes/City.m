//
//  City.m
//  PublicTransport
//
//  Created by Andris Spruds on 12/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import "City.h"
@implementation City

@synthesize code;

- (id)init:(NSString*)c {
	self.code = c;
	return self;
}

+ (City*)getByCode:(NSString*)code {
	City* city = nil;
	if([code isEqualToString:kRiga]) {
		city = [[City alloc] init:kRiga];
	}
	else if([code isEqualToString:kVilnius]) {
		city = [[City alloc] init:kVilnius];
	}
	else if([code isEqualToString:kKaunas]) {
		city = [[City alloc] init:kKaunas];
	}
	else if([code isEqualToString:kKlaipeda]) {
		city = [[City alloc] init:kKlaipeda];
	}			
	else if([code isEqualToString:kLiepaja]) {
		city = [[City alloc] init:kLiepaja];
	}
	else if([code isEqualToString:kTallinn]) {
		city = [[City alloc] init:kTallinn];
	}
	else if([code isEqualToString:kEstonia]) {
		city = [[City alloc] init:kEstonia];
	}
	else if([code isEqualToString:kVologda]) {
		city = [[City alloc] init:kVologda];
	}
	else if([code isEqualToString:kMinsk]) {
		city = [[City alloc] init:kMinsk];
	}
	else if([code isEqualToString:kDruskininkai]) {
		city = [[City alloc] init:kDruskininkai];
	}
	else if([code isEqualToString:kChelyabinsk]) {
		city = [[City alloc] init:kChelyabinsk];
	}
	else {
		[NSException exceptionWithName:@"unknownCityException" reason:@"Unknown city" userInfo:nil];
	}
	return [city autorelease];
}
				
-(void)dealloc {
	[code release];
	[super dealloc];
}
@end
