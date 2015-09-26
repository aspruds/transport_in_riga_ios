//
//  StopParser.m
//  PublicTransport
//
//  Created by Andris Spruds on 12/11/11.
//  Copyright 2011 none. All rights reserved.
//

#import "StopParser.h"
#import "StopHeader.h"
#import "Stop.h"
#import "HeaderParser.h"

@implementation StopParser

+(NSMutableArray*) parseStops:(NSString*)data {
	NSMutableArray* stops = [[NSMutableArray alloc] init];
	NSArray* lines = [data componentsSeparatedByString:@"\n"];
	
	NSString* latitude = nil;
	NSString* longitude = nil;
	NSString* stopsNearby = nil;
	NSString* name = nil;
	NSString* info = nil;
	NSString* street = nil;
	NSString* area = nil;
	NSString* city = nil;
	
	NSString* headerLine = [lines objectAtIndex:0];
	HeaderParser* hdr = [[HeaderParser alloc] init:headerLine];

	for(int lineIdx = 1; lineIdx < [lines count]; lineIdx++) {
		NSString* line = [lines objectAtIndex:lineIdx];
		NSArray* stopData = [[line componentsSeparatedByString:@";"] retain];
		
		NSString* id = [self getValue:stopData position:STOP_ID header:hdr];
		
		// latitude
		NSString* latitudeValue = [self getValue:stopData position:LATITUDE header:hdr];
		if(![self isEmpty:latitudeValue]) {
			if([latitudeValue isEqualToString:@"0"]) {
				latitudeValue = @"";
			}
				
			latitude = latitudeValue;
		}
				
		// longitude
		NSString* longitudeValue = [self getValue:stopData position:LONGITUDE header:hdr];
		if(![self isEmpty:longitudeValue]) {
			if([longitudeValue isEqualToString:@"0"]) {
				longitudeValue = @"";
			}
			
			longitude = longitudeValue;
		}		
		
		// stops
		NSString* stopsValue = [self getValue:stopData position:STOPS header:hdr];
		if(![self isEmpty:stopsValue]) {
			if([stopsValue isEqualToString:@"0"]) {
				stopsValue = @"";
			}
			
			stopsNearby = stopsValue;
		}			
		
		// name
		NSString* nameValue = [self getValue:stopData position:NAME header:hdr];
		if(![self isEmpty:nameValue]) {
			if([nameValue isEqualToString:@"0"]) {
				nameValue = @"";
			}
			
			name = nameValue;
		}
		
		// info
		NSString* infoValue = [self getValue:stopData position:INFO header:hdr];
		if(![self isEmpty:infoValue]) {
			if([infoValue isEqualToString:@"0"]) {
				infoValue = @"";
			}
			
			info = infoValue;
		}		
		
		// street
		NSString* streetValue = [self getValue:stopData position:STREET header:hdr];
		if(![self isEmpty:streetValue]) {
			if([streetValue isEqualToString:@"0"]) {
				streetValue = @"";
			}
			
			street = streetValue;
		}	

		// city
		NSString* cityValue = [self getValue:stopData position:CITY header:hdr];
		if(![self isEmpty:cityValue]) {
			if([cityValue isEqualToString:@"0"]) {
				cityValue = @"";
			}
			
			city = cityValue;
		}		

		Stop* stop = [[Stop alloc] init];
		stop.stopId = id;
		stop.latitude = [NSNumber numberWithInteger:[latitude intValue]];
		stop.longitude = [NSNumber numberWithInteger:[longitude intValue]];
		stop.name = name;
		stop.stopsNearby = stopsNearby;
		stop.info = info;
		stop.street = street;
		stop.area = area;
		stop.city = city;
		
		[stops addObject:stop];
		[stop release];
		[stopData release];
	}
	[hdr release];
	
	return [stops autorelease];
}

+(NSString*) getValue:(NSArray*)scheduleData position:(kStopHeader)pos header:(HeaderParser*)hdr {
	int position = [hdr getValue:[StopHeader toString:pos]];

	if([scheduleData count] <= position) {
		return nil;
	}

	NSString* value = [scheduleData objectAtIndex:position];
	return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(BOOL) isEmpty:(NSString*)value {
	if(value == nil) {
		return YES;
	}
	if([value isEqualToString:@""]) {
		return YES;
	}
	return NO;
}

@end
