//
//  DatabaseManager.m
//  PublicTransport
//
//  Created by Andris Spruds on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import "DatabaseManager.h"
#import "Route.h"
#import "Direction.h"
#import "Stop.h"
#import "StopSchedule.h"

@implementation DatabaseManager
@synthesize database;

static NSString* kDatabaseName = @"schedule.db";
static const int kDatabaseVersion = 4;

- (void)open {
	NSString* path = [self getDatabasePath];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL fileExists = [fileManager fileExistsAtPath:path];
	if(!fileExists) {
		[self copyDatabase];
	}
	
	[self openDatabase];
	if([database open]) {
		int currentDbVersion = [self getDatabaseVersion];
		if(currentDbVersion < kDatabaseVersion) {
			[self upgradeDatabase:currentDbVersion newVersion:kDatabaseVersion];
		}
	}
}

- (void) openDatabase {
	NSString* path = [self getDatabasePath];
	self.database = [FMDatabase databaseWithPath:path];
	if(![database open]) {
		NSLog(@"could not open database at %@", path);
		return;
	}
	else {
		[database setShouldCacheStatements:YES];
	}
}

- (void)close {
	if([database open]) {
		[database close];
	}
}

- (void) copyDatabase {
	NSString* path = [self getDatabasePath];
	NSString* readOnlyDatabasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseName];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error;
	BOOL fileCopied = [fileManager copyItemAtPath:readOnlyDatabasePath toPath:path error:&error];
	[fileManager release];
	
	if(!fileCopied) {
		NSAssert1(0, @"could not copy database, '%@'", [error localizedDescription]);
	}
}

- (NSString*) getDatabasePath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	NSString* writeableDatabasePath = [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
	return writeableDatabasePath;
}

- (void) deleteDatabase {
	NSString* path = [self getDatabasePath];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error;
	[fileManager removeItemAtPath:path error:&error];
	[fileManager release];
}

- (void) upgradeDatabase:(int)oldVersion newVersion:(int)version {
	NSLog(@"upgrading database from %i to %i", oldVersion, version);
	
	[self close];
	[self deleteDatabase];
	[self copyDatabase];
	[self openDatabase];
	[self setDatabaseVersion:version];
}

- (int) getDatabaseVersion {
	int version = [database longForQuery:@"PRAGMA user_version", 1];
	if([database hadError]) {
		NSLog(@"error retrieving db version, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
	}
	return version;
}

- (void) setDatabaseVersion:(int)newVersion {
	[database executeUpdate:[NSString stringWithFormat:@"PRAGMA user_version=%d", newVersion]];
	
	if([database hadError]) {
		NSLog(@"error setting db version, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
	}
}
				  
-(NSArray*) getRoutesByTransportType:(TransportType*)transportType {
	NSMutableArray* routes = [[NSMutableArray alloc] init];
		  
	FMResultSet* rs = [database 
		executeQuery:@"SELECT route_id, name, number FROM routes \
					   WHERE transport_type_id=? ORDER BY CAST(number AS integer) ASC", 
		transportType.transportTypeId];
	
	if([database hadError]) {
		NSLog(@"error while retrieving routes, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		return nil;
	}
	
	while ([rs next]) {
		Route* route = [[Route alloc] 
						initWithTitle:[NSNumber numberWithInt:[rs intForColumn:@"route_id"]]
						number:[rs stringForColumn:@"number"]
						title:[rs stringForColumn:@"name"]
						lowfloor: [NSNumber numberWithBool:NO]
						transportType:transportType];
		
		[routes addObject:route];
		[route release];
	}
	[rs close];
	return [routes autorelease];
}

-(NSArray*) getDirectionsByRoute:(Route*)route {
	NSMutableArray* directions = [[NSMutableArray alloc] init];
	
	FMResultSet* rs = [database 
		executeQuery:@"SELECT direction_id, name, type FROM directions WHERE route_id=? ORDER BY type ASC",
		route.routeId];
	
	if([database hadError]) {
		NSLog(@"error while retrieving directions, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		return nil;
	}
	
	while ([rs next]) {
		Direction* direction = [[Direction alloc]
						initWithName:[NSNumber numberWithInt:[rs intForColumn:@"direction_id"]]
						type:[rs stringForColumn:@"type"]
						name:[rs stringForColumn:@"name"]
						route: route];
		
		[directions addObject:direction];
		[direction release];
	}
	[rs close];
	return [directions autorelease];
}

- (NSArray*) getStopsByDirection:(Direction*)direction {
	NSMutableArray* stops = [[NSMutableArray alloc] init];
	
	FMResultSet* rs = [database 
					   executeQuery:@"SELECT s.stop_id, s.name, s.longitude, latitude \
					   FROM stops s, directions_stops ds \
					   WHERE ds.direction_id=? AND ds.stop_id=s.stop_id",
					   direction.directionId];
	
	if([database hadError]) {
		NSLog(@"error while retrieving stops, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		return nil;
	}
	
	while ([rs next]) {
		Stop* stop = [[Stop alloc]
			initWithName:[NSNumber numberWithInt:[rs intForColumn:@"stop_id"]]
			name:[rs stringForColumn:@"name"]
			latitude: [NSNumber numberWithFloat:[rs doubleForColumn:@"latitude"]]
			longitude: [NSNumber numberWithFloat:[rs doubleForColumn:@"longitude"]]];
					  
		stop.direction = direction;
		
		[stops addObject:stop];
		[stop release];
	}
	[rs close];
	return [stops autorelease];
}

- (NSArray*) getStopSchedule:(Stop*)stop {
	NSMutableArray* stopSchedules = [[NSMutableArray alloc] init];
	
	FMResultSet* rs = [database 
					   executeQuery:@"SELECT timing_id, hours, minutes, days_valid, \
					   is_lowfloor, is_shortened FROM stop_schedules \
					   WHERE stop_id=? AND direction_id=?",
					   stop.stopId, stop.direction.directionId];
	
	if([database hadError]) {
		NSLog(@"error while retrieving stop schedule, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		return nil;
	}
	
	while ([rs next]) {
		StopSchedule* stopSchedule = [[StopSchedule alloc]
									  init: [NSNumber numberWithInt:0]
									  timingId: [NSNumber numberWithInt:[rs intForColumn:@"timing_id"]]
									  hours: [NSNumber numberWithInt:[rs intForColumn:@"hours"]]
									  minutes: [NSNumber numberWithInt:[rs intForColumn:@"minutes"]]
									  daysValid: [NSNumber numberWithInt:[rs intForColumn:@"days_valid"]]
									  lowfloor: [NSNumber numberWithBool:[rs boolForColumn:@"is_lowfloor"]]
									  shortened: [NSNumber numberWithBool:[rs boolForColumn:@"is_shortened"]]];
		
		[stopSchedules addObject:stopSchedule];
		[stopSchedule release];
	}
	[rs close];
	return [stopSchedules autorelease];
}

- (BOOL) isStopAddedToFavourites:(Stop*)stop {
	BOOL isAdded = NO;
	
	FMResultSet* rs = [database executeQuery:@"SELECT COUNT(*) FROM favourite_stops WHERE stop_id=? AND direction_id=?",
	stop.stopId, stop.direction.directionId];
	
	if([database hadError]) {
		NSLog(@"error while checking if stop is added to favourites, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		return YES;
	}
	
	if ([rs next]) {
		int count = [rs intForColumnIndex:0];
		if (count > 0) {
			isAdded = YES;
		}
	}
	[rs close];
	
	return isAdded;
}

- (BOOL) isRouteAddedToFavourites:(Route*)route {
	BOOL isAdded = NO;
	
	FMResultSet* rs = [database executeQuery:@"SELECT COUNT(*) FROM favourite_routes WHERE route_id=?", route.routeId];
	
	if([database hadError]) {
		NSLog(@"error while checking if route is added to favourites, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		return YES;
	}
	
	if ([rs next]) {
		int count = [rs intForColumnIndex:0];
		if (count > 0) {
			isAdded = YES;
		}
	}
	[rs close];
	
	return isAdded;
}

- (void) addRouteToFavourites:(Route*)route {
	if(![self isRouteAddedToFavourites:route]) {
		[database executeUpdate:@"INSERT INTO favourite_routes (route_id) VALUES (?)", route.routeId];
		NSLog(@"route added to favs");
	}
}

- (void) addStopToFavourites:(Stop*)stop {
	if(![self isStopAddedToFavourites:stop]) {
		[database executeUpdate:@"INSERT INTO favourite_stops (stop_id, direction_id) VALUES(?,?)",
		 stop.stopId, stop.direction.directionId];
		NSLog(@"stop added to favs");
	}
}

- (NSArray*) getFavouriteRoutes {
	NSMutableArray* favouriteRoutes = [[NSMutableArray alloc] init];
	
	FMResultSet* rs = [database executeQuery:@"SELECT r.route_id, r.name, r.number, r.transport_type_id, \
					   FROM routes r, favourite_routes fr \
					   WHERE r.route_id=fr.route_id"];
	
	if([database hadError]) {
		NSLog(@"error while retrieving favourite routes, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		return nil;
	}
	
	while ([rs next]) {
		TransportType* transportType = [TransportType transportTypeById:[rs intForColumnIndex:3]];
		
		Route* route = [[Route alloc] 
						initWithTitle:[NSNumber numberWithInt:[rs intForColumnIndex:0]]
						number:[rs stringForColumnIndex:1]
						title:[rs stringForColumnIndex:2]
						lowfloor: [NSNumber numberWithBool:NO]
						transportType:transportType];
		
		[favouriteRoutes addObject:route];
		[route release];
	}
	[rs close];
	return [favouriteRoutes autorelease];
}

- (NSArray*) getFavouriteStops {
	NSMutableArray* favouriteStops = [[NSMutableArray alloc] init];
	
	FMResultSet* rs = [database executeQuery:@"SELECT r.route_id, r.name, r.number, r.transport_type_id, \
		d.direction_id, d.name, d.type, s.stop_id, s.name, s.latitude, s.longitude \
		FROM stops s, favourite_stops fs, directions_stops ds, directions d, routes r \
		WHERE s.stop_id = fs.stop_id AND fs.stop_id = ds.stop_id AND fs.direction_id = ds.direction_id \
		AND ds.direction_id = d.direction_id AND d.route_id = r.route_id"];
	
	if([database hadError]) {
		NSLog(@"error while retrieving favourite stops, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		return nil;
	}
	
	while ([rs next]) {
		TransportType* transportType = [TransportType transportTypeById:[rs intForColumnIndex:3]];
		
		Route* route = [[Route alloc] 
						initWithTitle:[NSNumber numberWithInt:[rs intForColumnIndex:0]]
						number:[rs stringForColumnIndex:1]
						title:[rs stringForColumnIndex:2]
						lowfloor: [NSNumber numberWithBool:NO]
						transportType:transportType];
		
		Direction* direction = [[Direction alloc]
								initWithName:[NSNumber numberWithInt:[rs intForColumnIndex:4]]
								type:[rs stringForColumnIndex:5]
								name:[rs stringForColumnIndex:6]
								route: route];
		
		Stop* stop = [[Stop alloc]
					  initWithName:[NSNumber numberWithInt:[rs intForColumnIndex:7]]
					  name:[rs stringForColumnIndex:8]
					  latitude: [NSNumber numberWithFloat:[rs doubleForColumnIndex:9]]
					  longitude: [NSNumber numberWithFloat:[rs doubleForColumnIndex:10]]];
		stop.direction = direction;
		
		[favouriteStops addObject:stop];
		[route release];
		[direction release];
		[stop release];
	}
	[rs close];
	return [favouriteStops autorelease];
}

- (void) deleteFavouriteStop:(Stop*)stop {
	[database executeUpdate:@"DELETE FROM favourite_stops WHERE stop_id=? AND direction_id=?",
	 stop.stopId,
	 stop.direction.directionId];
	
	if([database hadError]) {
		NSLog(@"error while deleting favourite stop, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
	}
}

- (void) deleteFavouriteRoute:(Route*)route {
	[database executeUpdate:@"DELETE FROM favourite_routes WHERE route_id=?",
	 route.routeId];
	
	if([database hadError]) {
		NSLog(@"error while deleting favourite route, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
	}
}

- (void)dealloc {
	[database release];
	[super dealloc];
}
@end
