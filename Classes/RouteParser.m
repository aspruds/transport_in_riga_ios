//
//  RouteParser.m
//  PublicTransport
//
//  Created by Andris Spruds on 12/13/11.
//  Copyright 2011 none. All rights reserved.
//

#import "RouteParser.h"
#import "RouteHeader.h"
#import "Route.h"
#import "HeaderParser.h"

@implementation RouteParser

+(int*) intListToArray:(NSMutableArray*)list {
	int* array = calloc([list count]+1, sizeof(int));
	for(int pos = 0; pos < [list count]; pos++) {
		array[pos] = [[list objectAtIndex:pos] intValue];
	}
	return array;
}

+(NSMutableArray*) parseRoutes:(NSString*)data {
	NSMutableArray* routes = [[NSMutableArray alloc] init];
	NSArray* lines = [data componentsSeparatedByString:@"\n"];
	
	NSString* authority = nil;
	NSString* routeNumber = nil;
	NSString* routeName = nil;
	NSString* city = nil;
	NSString* transportType = nil;
	NSString* operator = nil;
	NSString* validityPeriods = nil;
	NSString* specialDates = nil;
	NSString* weekdays = nil;
	
	int order = 0;
	int recordId = 0;
	
	NSString* headerLine = [lines objectAtIndex:0];
	HeaderParser* hdr = [[HeaderParser alloc] init:headerLine];
	
	for(int lineIdx = 1; lineIdx < [lines count]; lineIdx++) {
		NSString* line = [lines objectAtIndex:lineIdx];
		
		if ([line hasPrefix:@"#"]) {
			[self parseComment:routes line:line];
		}
		else {
			NSArray* scheduleData = [[line componentsSeparatedByString:@";"] retain];
			
			// authority
			NSString* authorityValue = [self getValue:scheduleData position:AUTHORITY header:hdr];
			if(![self isEmpty:authorityValue]) {
				if([authorityValue isEqualToString:@"0"]) {
					authorityValue = @"";
				}
				
				authority = authorityValue;
			}
			
			// special dates
			if([authority isEqualToString:@"SpecialDates"]) {
				// validity periods
				/*
				NSString* validityPeriodsString = [self getValue:scheduleData position:kValidityPeriods];
				if(![validityPeriodsString isEqualToString:@""]) {
					NSArray* validityPeriodParts = [validityPeriodsString componentsSeparatedByString:@","];
				}
				*/
				continue;
			}	
			order++;
			
			// route number
			NSString* routeNumberValue = [self getValue:scheduleData position:ROUTE_NUM header:hdr];
			if(![self isEmpty:routeNumberValue]) {
				if([routeNumberValue isEqualToString:@"0"]) {
					routeNumberValue = @"";
				}
				
				routeNumber = routeNumberValue;
				order = 1;
			}
			
			// route name
			NSString* routeNameValue = [self getValue:scheduleData position:ROUTE_NAME header:hdr];
			if(![self isEmpty:routeNameValue]) {
				routeName = routeNameValue;
			}	
			
			// city
			NSString* cityValue = [self getValue:scheduleData position:ROUTE_CITY header:hdr];
			if(![self isEmpty:cityValue]) {
				if([cityValue isEqualToString:@"0"]) {
					cityValue = @"";
				}
				
				city = cityValue;
				order = 1;
			}
			
			// transportType
			NSString* transportTypeValue = [self getValue:scheduleData position:TRANSPORT header:hdr];
			if(![self isEmpty:transportTypeValue]) {
				if([transportTypeValue isEqualToString:@"0"]) {
					transportTypeValue = @"";
				}
				
				transportType = transportTypeValue;
				order = 1;
			}			
			
			// operator
			NSString* operatorValue = [self getValue:scheduleData position:OPERATOR header:hdr];
			if(![self isEmpty:operatorValue]) {
				if([operatorValue isEqualToString:@"0"]) {
					operatorValue = @"";
				}
				
				operator = operatorValue;
			}	
			
			// validityPeriods
			NSString* validityPeriodsValue = [self getValue:scheduleData position:VALIDITY_PERIODS header:hdr];
			if(![self isEmpty:validityPeriodsValue]) {
				if([validityPeriodsValue isEqualToString:@"0"]) {
					validityPeriodsValue = @"";
				}
				
				validityPeriods = validityPeriodsValue;
			}	
			
			// specialDates
			NSString* specialDatesValue = [self getValue:scheduleData position:SPECIAL_DATES header:hdr];
			if(![self isEmpty:specialDatesValue]) {
				if([specialDatesValue isEqualToString:@"0"]) {
					specialDatesValue = @"";
				}
				
				specialDates = specialDatesValue;
			}		
			
			// weekdays
			NSString* weekdaysValue = [self getValue:scheduleData position:WEEKDAYS header:hdr];
			if(![self isEmpty:weekdaysValue]) {
				if([weekdaysValue isEqualToString:@"0"]) {
					weekdaysValue = @"";
				}
				
				weekdays = weekdaysValue;
			}			
			
			// various
			NSString* directionType = [self getValue:scheduleData position:ROUTE_TYPE header:hdr];
			NSString* routeTag = [self getValue:scheduleData position:ROUTE_TAG header:hdr];
			if([routeTag isEqualToString:@""]) {
				routeTag = nil;
			}
			
			NSString* commercial = [self getValue:scheduleData position:COMMERCIAL header:hdr];	
			
			NSString* routeStops = [self getValue:scheduleData position:ROUTE_STOPS header:hdr];
			NSArray* routeStopsArray = [routeStops componentsSeparatedByString:@","];
			for(int stopIdx = 0; stopIdx < [routeStopsArray count]; stopIdx++) {
				NSString* stopId = [routeStopsArray objectAtIndex:stopIdx];
				
				int stopType = 0;
				if([stopId hasPrefix:@"e"]) {
					stopType = 1;
					stopId = [stopId substringFromIndex:1];
				}
				else if ([stopId hasPrefix:@"x"]) {
					stopType = 2;
					stopId = [stopId substringFromIndex:1];
				}				
			}
			
			NSString* times = [lines objectAtIndex:++lineIdx]; // next line
			
			Route* route = [[Route alloc] init];
			route.authority = authority;
			route.number = routeNumber;
			route.name = routeName;
			route.city = city;
			route.transportType = [TransportType getByCode:transportType];
			route.operator = operator;
			route.validityPeriods = validityPeriods;
			route.specialDates = specialDates;
			route.weekdays = weekdays;
			route.directionType = directionType;
			route.routeTag = routeTag;
			route.commercial = commercial;
			route.stops = routeStops;
			route.times = times;
			route.order = [NSNumber numberWithInt:order];
			route.routeId = [NSNumber numberWithInt:++recordId];
			
			[routes addObject:route];
			[route release];
			[scheduleData release];
		}
	}
	
	return [routes autorelease];
}

+(void) parseComment:(NSMutableArray*)routes line:(NSString*)line {
}

+(NSString*) getValue:(NSArray*)scheduleData position:(kRouteHeader)pos header:(HeaderParser*)hdr  {
	int position = [hdr getValue:[RouteHeader toString:pos]];
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

+(RawSchedule*) explodeTimes:(NSString*)timesString {
	NSMutableArray* times = [[NSMutableArray alloc] init];
	NSArray* timeParts = [[timesString componentsSeparatedByString:@","] retain];
	int* tags = calloc([timeParts count], sizeof(int));
	
	int parserPosition = -1;
	
	int timeCounter = 0;
	for(; ++parserPosition < [timeParts count];) {
		NSString* part = [timeParts objectAtIndex:parserPosition];
		if([part isEqualToString:@""]) {
			break;
		}
		
		NSString* sign = [part substringToIndex:1];
		NSString* firstDigit = nil;
		if([part length] > 1) {
			firstDigit = [part substringWithRange:NSMakeRange(1, 1)];
		}
		
		if(([sign isEqualToString:@"+"] || [sign isEqualToString:@"-"]) && [firstDigit isEqualToString:@"0"]) {
			tags[parserPosition] = 1;
		}
		
		if([part hasPrefix:@"+"]) {
			part = [part substringFromIndex:1];
		}
		
		timeCounter += [part intValue];
		[times addObject: [NSNumber numberWithInt:timeCounter]];
	}
	
	int* tagsReduced = calloc(parserPosition+1, sizeof(int));
	for(int pos = 0; pos < parserPosition; pos++) {
		tagsReduced[pos] = tags[pos];
	}
	free(tags);
	tags = tagsReduced;
	
	int tagsSize = parserPosition;
		
	int* validFrom = calloc(parserPosition+1, sizeof(int));
	int* validTo = calloc(parserPosition+1, sizeof(int));
	int* workdays = calloc(parserPosition+1, sizeof(int));
	
	// validFrom
	for(int pos = 0, partsLength = [timeParts count]; ++parserPosition < partsLength;) {
		int value = [[timeParts objectAtIndex:parserPosition] intValue];
		
		NSString* endIndexString = [timeParts objectAtIndex:++parserPosition];
		int endIndex = [endIndexString intValue];
		
		if([endIndexString isEqualToString:@""]) {
			endIndex = [times count] - pos;
			partsLength = 0; // break loop
		}
		
		while(endIndex-- > 0) {
			validFrom[pos++] = value;
		}
	}
	parserPosition--; // rewind to last char
	
	// validTo
	for(int pos = 0, partsLength = [timeParts count]; ++parserPosition < partsLength;) {
		int value = [[timeParts objectAtIndex:parserPosition] intValue];
		
		NSString* endIndexString = [timeParts objectAtIndex:++parserPosition];
		int endIndex = [endIndexString intValue];
		
		if([endIndexString isEqualToString:@""]) {
			endIndex = [times count] - pos;
			partsLength = 0; // break loop
		}
		
		while(endIndex-- > 0) {
			validTo[pos++] = value;
		}
	}
	parserPosition--; // rewind to last char
	
	// workdays
	for(int pos = 0, partsLength = [timeParts count]; ++parserPosition < partsLength;) {
		int value = [[timeParts objectAtIndex:parserPosition] intValue];
		
		NSString* endIndexString = [timeParts objectAtIndex:++parserPosition];
		int endIndex = [endIndexString intValue];
		
		if([endIndexString isEqualToString:@""]) {
			endIndex = [times count] - pos;
			partsLength = 0; // break loop
		}
		
		while(endIndex-- > 0) {
			workdays[pos++] = value;
		}
	}
	parserPosition--; // rewind to last char
	
	int timesSize = [times count];
	for(int q = timesSize, positionFromEnd = timesSize, offset = 5, partsLength = [timeParts count];
		++parserPosition < partsLength - 1;) {
		
		offset += [[timeParts objectAtIndex:parserPosition] intValue] - 5;
		
		NSString* endIndexString = [timeParts objectAtIndex:++parserPosition];
		int endIndex = [endIndexString intValue];
		
		if([endIndexString isEqualToString:@""]) {
			endIndex = positionFromEnd;
			positionFromEnd = 0;
		}
		else {
			positionFromEnd = positionFromEnd - endIndex;
		}
		
		while (endIndex-- > 0) {
			int prevValuePos = q - timesSize;
			NSNumber* prevValue = [times objectAtIndex:prevValuePos];
			
			NSNumber* newValue = [NSNumber numberWithInt:offset + [prevValue intValue]];
			[times addObject:newValue];
			++q;
		}
		
		// reset
		if(positionFromEnd <= 0) {
			positionFromEnd = timesSize;
			offset = 5;
		}
	}
	
	if(tagsSize != [timeParts count]) {
		[NSException exceptionWithName:@"routeParserException" 
			reason:@"error while decoding times, arrays of different lengths" userInfo:nil];
	}
	
	if([times count] > 0 && tagsSize > 0) {
		if([times count] % tagsSize != 0) {
			[NSException exceptionWithName:@"routeParserException" 
				reason:@"error while decoding times, times.size is not multiplied by tags.size" userInfo:nil];
		}
	}
	
	RawSchedule* schedule = [[RawSchedule alloc] init];
	schedule.tags = tags;
	schedule.tagsSize = tagsSize;
	schedule.validFrom = validFrom;
	schedule.validTo = validTo;
	schedule.workdays = workdays;
	schedule.times = [self intListToArray: times];
	schedule.timesSize = [times count];
	
	[times release];
	[timeParts release];
	return [schedule autorelease];
}
/*
+ (NSString*) printArray:(int *)array size:(int)size {
	NSString* result = @"";
	for(int pos = 0; pos < size; pos++) {
		result = [result stringByAppendingFormat:@"%d,", array[pos]];
	}
	return result;
}
*/
@end
