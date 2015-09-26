//
//  RouteService.m
//  PublicTransport
//
//  Created by Andris Spruds on 12/11/11.
//  Copyright 2011 none. All rights reserved.
//

#import "RouteService.h"
#import "RouteParser.h"
#import "StopParser.h"
#import "ZipFile.h"
#import "FileInZipInfo.h"
#import "ZipReadStream.h"
#import "NSStringExtensions.h"
#import "RawSchedule.h"
#import "StopSchedule.h"
#import "PreferencesService.h"
#import "City.h"

@implementation RouteService

@synthesize parsedRoutes;
@synthesize parsedStops;

static RouteService* instance = nil;

- (id) initWithCity: (City*)city {
	[self updateSchedules: city];
	return self;
}

+ (RouteService*) getInstance {
	if(instance == nil) {
		City* city = [PreferencesService getCurrentCity];
		NSLog(@"Initializing Routes service, city: %@", city.code);
		instance = [[RouteService alloc] initWithCity:city];
	}
	return instance;
}

- (ScheduleData*) getScheduleData: (City*)city {
	ScheduleData* scheduleData = [[ScheduleData alloc] init];
	
	NSString* fileName = [NSString stringWithFormat:@"%@%@", city.code, @".zip"];
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* dir = [paths objectAtIndex:0];
	NSString* filePath = [dir stringByAppendingPathComponent: [NSString stringWithFormat:@"routes/%@", fileName]];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		filePath = [[NSBundle mainBundle] pathForResource:city.code ofType:@"zip"];
	}
	
	ZipFile* zipFile = [[ZipFile alloc] initWithFileName:filePath mode:ZipFileModeUnzip];
	[zipFile goToFirstFileInZip];
	
	BOOL continueReading = YES;
	while(continueReading) {
		// get file info
		FileInZipInfo* info = [zipFile getCurrentFileInZipInfo];
		
		// Read data into buffer
		ZipReadStream* stream = [zipFile readCurrentFileInZip];
		NSMutableData* data = [[NSMutableData alloc] initWithLength:info.length];
		[stream readDataWithBuffer:data];
		
		NSString* stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		if([info.name isEqualToString:@"routes.txt"]) {
			scheduleData.routes = stringData;
		}
		else if([info.name isEqualToString:@"stops.txt"]) {
			scheduleData.stops = stringData;
		}
		[stringData release];
		
		[stream finishedReading];
		[data release];
		continueReading = [zipFile goToNextFileInZip];
	}
	[zipFile close];
	[zipFile release];
	
	if(scheduleData.routes == nil || scheduleData.stops == nil) {
		[NSException exceptionWithName:@"routeServiceException" 
								reason:@"could extract route data from zip storage" userInfo:nil];
	}
	return [scheduleData autorelease];
}

- (void) updateSchedules:(City*)city {
	ScheduleData* data = [[self getScheduleData:city] retain];	
	parsedRoutes = [[RouteParser parseRoutes:data.routes] retain];
	parsedStops = [[StopParser parseStops:data.stops] retain];
	[data release];
}

- (NSArray*) getTransportTypes {
	NSMutableSet* transportTypesSet = [[NSMutableSet alloc] init];
	
	for(Route* route in parsedRoutes) {
		[transportTypesSet addObject:route.transportType];
	}
	
	NSArray* transportTypes = [transportTypesSet allObjects];
	[transportTypesSet release];

	return [transportTypes sortedArrayUsingComparator:^(id a, id b) {
		TransportType* first = (TransportType*)a;
		TransportType* second = (TransportType*)b;
		
		NSNumber* firstOrder = [NSNumber numberWithInt:first.orderId];
		NSNumber* secondOrder = [NSNumber numberWithInt:second.orderId];
		return [firstOrder compare:secondOrder];
	}];
}

- (Route*) getFullRoute: (Route*)incompleteRoute {
	Route* fullRoute = nil;
	
	NSArray* rawRoutes = [[self getDirectionsByRoute:incompleteRoute] retain];
	for(Route* rawRoute in rawRoutes) {
		// only show the first route
		if([rawRoute.order intValue] == 1) {
			fullRoute = rawRoute;
			break;
		}
	}
	[rawRoutes release];
	
	if(fullRoute == nil) {
		[NSException exceptionWithName:@"routeServiceException" 
								reason:@"could not find full route" userInfo:nil];
	}
	return fullRoute;
}

- (Route*) getFullDirection: (Route*)incompleteDirection {
	Route* fullRoute = nil;
	
	NSArray* rawRoutes = [[self getDirectionsByRoute:incompleteDirection] retain];
	if([rawRoutes count] > 0) {
		Route* rawRoute = nil;
		for(int pos=0; pos < [rawRoutes count]; pos++) {
			rawRoute = [rawRoutes objectAtIndex:pos];
			
			// only show the first route
			if([rawRoute.directionType isEqualToString:incompleteDirection.directionType]) {
				fullRoute = rawRoute;
				break;
			}
		}
	}
	[rawRoutes release];
	
	if(fullRoute == nil) {
		[NSException exceptionWithName:@"routeServiceException" 
								reason:@"could not find full route" userInfo:nil];
	}
	return fullRoute;
}

- (NSArray*) getStopsByRoute: (Route*)route {
	NSMutableArray* stopsByDirection = [[NSMutableArray alloc] init];
	NSString* stopIdString = route.stops;
	
	if(stopIdString != nil) {
		NSArray* stopIds = [stopIdString componentsSeparatedByString:@","];
		for(NSString* stopId in stopIds) {
			for(Stop* rawStop in self.parsedStops) {				
				if([rawStop.stopId isEqualToString:stopId]) {
					Stop* stop = [Stop alloc];
					
					stop.stopId =  rawStop.stopId;
					stop.name = rawStop.name;
					stop.city = rawStop.city;
					stop.info = rawStop.info;
					stop.latitude = rawStop.latitude;
					stop.longitude = rawStop.longitude;
					stop.route = route;
					
					[stopsByDirection addObject:stop];
					[stop release];
				}
			}
		}
	}
							  
	return [stopsByDirection autorelease];
}

- (Stop*) getStop: (NSString*)stopId route:(Route*)route {
	Stop* stop = nil;
	
	NSArray* stops = [[self getStopsByRoute:route] retain];
	for(int pos = 0; pos < [stops count]; pos++) {
		Stop* currentStop = [stops objectAtIndex:pos];
		if([currentStop.stopId isEqualToString:stopId]) {
			stop = currentStop;
			break;
		}
	}
	[stops release];
	
	if(stop == nil) {
		[NSException exceptionWithName:@"routeServiceException" 
								reason:@"could not find stop by id" userInfo:nil];
	}
	return stop;
}
							  
- (NSArray*) getRoutesByTransportType: (TransportType*)transportType {

	NSMutableArray* foundRoutes = [[[NSMutableArray alloc] init] autorelease];

	for(int pos = 0; pos < [self.parsedRoutes count]; pos++) {
		Route* route = [self.parsedRoutes objectAtIndex:pos];
		
		if(transportType != nil) {
			if(![route.transportType.code isEqualToString:transportType.code]) {
				continue;
			}
			if([route.order intValue] != 1) {
				continue;
			}
			[foundRoutes addObject:route];
		}
	}
	
	// TODO, improve sorting
	return [foundRoutes sortedArrayUsingComparator:^(id a, id b) {
		Route* first = (Route*)a;
		Route* second = (Route*)b;
		
		NSString* str1 = first.number;
		NSString* str2 = second.number;
		int len1 = [str1 length];
		int len2 = [str2 length];
		
		if(len1 == 0) {
			return len2 == 0 ? NSOrderedSame : NSOrderedAscending;
		}
		else if (len2 == 0) {
			return NSOrderedDescending;
		}
		
		return NSOrderedSame;
	}];
}
							  
- (NSArray*) getDirectionsByRoute: (Route*)route onlyMainDirections:(BOOL)onlyMainDirections {
	NSArray* directions = [[self getDirectionsByRoute:route] retain];
	
	if(onlyMainDirections == YES) {
		Route* mainDirection = nil;
		for(Route* dir in directions) {
			if([dir.order intValue] == 1) {
				mainDirection = dir;
				break;
			}
		}
		
		Route* reverseDirection = [self findReverseDirection:directions mainDirection:mainDirection];
		if(mainDirection != nil && reverseDirection != nil) {
			NSMutableArray* filteredDirections = [[NSMutableArray alloc] init];
			[filteredDirections addObject:mainDirection];
			[filteredDirections addObject:reverseDirection];
			
			[directions release];
			return [filteredDirections autorelease];
		}
	}
	
	[directions release];
	return directions;
}

/*
 B>A
 B?>A
 B?>A?
 B?>
 >A?
*/
- (Route*) findReverseDirection: (NSArray*)directions mainDirection:(Route*)mainDirection {
	NSArray* typeParts = [mainDirection.directionType componentsSeparatedByString:@"-"];
	NSString* typeFrom = [typeParts objectAtIndex:0];
	NSString* typeTo = [typeParts objectAtIndex:1];
	
	// reverse
	typeParts = [[typeParts reverseObjectEnumerator] allObjects];
	NSString* reverseType = [typeParts componentsJoinedByString:@"-"];
	NSString* weekdays = mainDirection.weekdays;
	
	// level one
	for (Route* otherDirection in directions) {
		if([otherDirection.directionType isEqualToString:reverseType]) {
			return otherDirection;
		}
	}
	
	// level two
	for (Route* otherDirection in directions) {
		if(![otherDirection.weekdays isEqualToString:weekdays]) {
			continue;
		}
		
		NSArray* otherTypeParts = [otherDirection.directionType componentsSeparatedByString:@"-"];
		NSString* otherTypeFrom = [otherTypeParts objectAtIndex:0];
		NSString* otherTypeTo = [otherTypeParts objectAtIndex:([otherTypeParts count]-1)];
		
		if([otherTypeTo isEqualToString:typeFrom] && [otherTypeFrom characterAtIndex:0] == [typeTo characterAtIndex:0]) {
			return otherDirection;
		}
	}
	
	// level three
	for (Route* otherDirection in directions) {
		if(![otherDirection.weekdays isEqualToString:weekdays]) {
			continue;
		}
		
		NSArray* otherTypeParts = [otherDirection.directionType componentsSeparatedByString:@"-"];
		NSString* otherTypeFrom = [otherTypeParts objectAtIndex:0];
		NSString* otherTypeTo = [otherTypeParts objectAtIndex:([otherTypeParts count]-1)];
		
		if([otherTypeTo characterAtIndex:0]==[typeFrom characterAtIndex:0] &&
		   [otherTypeFrom characterAtIndex:0]==[typeTo characterAtIndex:0]) {
			return otherDirection;
		}
	}
	
	// level four
	for (Route* otherDirection in directions) {
		if(![otherDirection.weekdays isEqualToString:weekdays]) {
			continue;
		}
		
		NSArray* otherTypeParts = [otherDirection.directionType componentsSeparatedByString:@"-"];
		NSString* otherTypeTo = [otherTypeParts objectAtIndex:([otherTypeParts count]-1)];
		
		if([otherTypeTo characterAtIndex:0]==[typeFrom characterAtIndex:0]) {
			return otherDirection;
		}
	}
	
	// level five
	for (Route* otherDirection in directions) {
		if(![otherDirection.weekdays isEqualToString:weekdays]) {
			continue;
		}
		
		NSArray* otherTypeParts = [otherDirection.directionType componentsSeparatedByString:@"-"];
		NSString* otherTypeFrom = [otherTypeParts objectAtIndex:0];
		
		if([otherTypeFrom characterAtIndex:0]==[typeTo characterAtIndex:0]) {
			return otherDirection;
		}
	}
	
	return nil;
}
							
- (NSArray*) getDirectionsByRoute: (Route*)route {
	NSArray* rawRoutes = parsedRoutes;
	NSMutableArray* result = [[NSMutableArray alloc] init];
	
	for(Route* rawRoute in rawRoutes) {
		if(![rawRoute.city isEqualToString:route.city]) {
			continue;
		}
		
		if(![rawRoute.transportType.code isEqualToString:route.transportType.code]) {
			continue;
		}
		
		if(![rawRoute.number isEqualToString:route.number]) {
			continue;
		}
		
		[result addObject:rawRoute];
	}
	
	return [result autorelease];
}
							  
- (NSArray*) getStopScheduleByStop: (Stop*)stop {
	NSMutableArray* schedules = [[NSMutableArray alloc] init];
	
	Route* route = stop.route;
	NSArray* routes = [[self getDirectionsByRoute:route] retain];
	
	// split direction type
	NSString* direction = route.directionType;
	NSArray* directionParts = [direction componentsSeparatedByString:@"-"];
	
	NSString* directionFrom = [directionParts objectAtIndex:0];
	NSString* directionTo = [directionParts objectAtIndex:([directionParts count]-1)];
	
	NSString* directionFromFirst = [directionFrom substringWithRange:NSMakeRange(0, 1)];
	NSString* directionToFirst = [directionTo substringWithRange:NSMakeRange(0, 1)];
	
	for(Route* candidateRoute in routes) {
		NSString* cndDirection = candidateRoute.directionType;
		if(route.routeTag != nil && [candidateRoute.routeId intValue] != [route.routeId intValue]) {
			continue;
		}
		
		if([cndDirection indexOf:direction] < 0
		   && [direction indexOf:cndDirection] < 0
		   && [cndDirection indexOf:@"-d"] < 0
		   && ![directionFrom isEqualToString:directionTo]
		   && ([cndDirection indexOf:directionTo] == 0
		   || [cndDirection indexOf:directionFrom] == ([cndDirection length]-1)
		   || [cndDirection indexOf:[NSString stringWithFormat:@"-%@", directionToFirst]] < 0
		   && [cndDirection indexOf:[NSString stringWithFormat:@"%@-", directionFrom]] < 0
		   && [cndDirection indexOf:[NSString stringWithFormat:@"%@-", directionFromFirst]] < 0 
		   && [cndDirection indexOf:@"c"] < 0
		   || [cndDirection indexOf:@"c"] >= ([cndDirection length]-2))) {
			   
			   continue;
		}
		   
	   NSArray* stops = [self getStopsByRoute:candidateRoute];
	   int stopIdx = [stops indexOfObject:stop];
	   if(stopIdx == NSNotFound) {
		   continue;
	   }
	
	   RawSchedule* schedule = [[self explodeTimes:candidateRoute.times] retain];
		
	   for(int i=0; i < schedule.tagsSize; i++) {
		   int pos = i + (stopIdx * schedule.tagsSize);
		   if(pos > (schedule.timesSize - 1)) {
			   continue;
		   }
		   
		   int time = schedule.times[pos];
		   if(time < 0) {
			   continue;
		   }
		   
		   int hours = time / 60;
		   int minutes = time % 60;
		   
		   StopSchedule* stopSchedule = [[StopSchedule alloc] init];
		   stopSchedule.stop = stop;
		   stopSchedule.daysValid = [NSNumber numberWithInt:schedule.workdays[i]];
		   stopSchedule.route = stop.route;
		   stopSchedule.hours = [NSNumber numberWithInt:hours];
		   stopSchedule.minutes = [NSNumber numberWithInt:minutes];
		   stopSchedule.lowfloor = schedule.tags[i] == 0 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
		   stopSchedule.shortened = [NSNumber numberWithBool:NO];
		   stopSchedule.changed = [NSNumber numberWithBool:NO];
		   
		   int routeTag = [self getDirectionTag:candidateRoute.directionType];
		   BOOL isOther = NO;
		   
		   if(![route.directionType isEqualToString:candidateRoute.directionType] 
			  && ![route.name isEqualToString:candidateRoute.name]) {
			   isOther = YES;
		   }
		   
		   if(routeTag == -1 /* no tag */ || isOther && [directionToFirst isEqualToString:@"d"]) {
			   routeTag = -1;
		   }
		   
		   if(routeTag != -1 && isOther) {
			   stopSchedule.shortened = [NSNumber numberWithBool:YES];
		   }
		   [schedules addObject:stopSchedule];
		   [stopSchedule release];
	   }
	   [schedule release];
	}
	// TODO sort
	[routes release];
	return [schedules autorelease];
}
							  
- (int) getDirectionTag: (NSString*)directionType {
	int tag = -1;
	
	if([directionType indexOf:@"-d"] >= 0) {
		tag = 0;
		return tag;
	}
	if([directionType indexOf:@"2"] >= 0) {
		tag = 2;
		return tag;
	}
	if([directionType indexOf:@"3"] >= 0) {
		tag = 3;
		return tag;
	}
	
	NSRegularExpression* matcher = [[NSRegularExpression alloc] 
		initWithPattern:@"[dcefghijklmnopqrsuvwyz]" options:NSRegularExpressionCaseInsensitive error:nil];
	
	NSRange pos = [matcher rangeOfFirstMatchInString:directionType options:0 range:NSMakeRange(0, [directionType length])];
	[matcher release];
	
	if(!NSEqualRanges(pos, NSMakeRange(NSNotFound, 0))) {
		int underscorePos = [directionType indexOf:@"_"];
		if(underscorePos < 0 || underscorePos > pos.location) {
			tag = 1;
			return tag;
		}
	}
	return tag;
}																		   
							  
- (RawSchedule*) explodeTimes: (NSString*) timesInput {
	return [RouteParser explodeTimes:timesInput];
}

-(void) dealloc {
	[parsedRoutes release];
	[parsedStops release];
	[super dealloc];
}

@end
