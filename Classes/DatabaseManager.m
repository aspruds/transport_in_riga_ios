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
static const int kDatabaseVersion = 1;

- (void)open {
	NSString* path = [self getDatabasePath];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL fileExists = [fileManager fileExistsAtPath:path];
	
	[self openDatabase];
	if(![database open]) {
		@throw([NSException exceptionWithName:@"databaseServiceException" 
								reason:@"could not open database" userInfo:nil]);
		return;
	}
	
	if(!fileExists) {
		[self createDatabase];
		NSLog(@"created database: %@", kDatabaseName);
	}
	
	int currentDbVersion = [self getDatabaseVersion];
	if(currentDbVersion < kDatabaseVersion) {
		[self upgradeDatabase:currentDbVersion newVersion:kDatabaseVersion];
	}
}

- (void) createDatabase {
	[database 
	 executeUpdate:@"CREATE TABLE favourite_stops (\
	 favourite_id integer not null primary key autoincrement,\
	 stop_id text not null, \
	 city_code text not null, \
	 transport_type_code text not null, \
	 route_number text not null, \
	 route_direction text not null, \
	 app_city_code text not null \
	 );"];
	
	if([database hadError]) {
		NSLog(@"error while creating favourite_stops table, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
	}
	
	[database 
	 executeUpdate:@"CREATE TABLE favourite_routes (\
	 favourite_id integer not null primary key autoincrement,\
	 city_code text not null, \
	 transport_type_code text not null, \
	 route_number text not null, \
	 app_city_code text not null \
	 );"];
	
	if([database hadError]) {
		NSLog(@"error while creating favourite_routes table, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
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

- (NSString*) getDatabasePath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	NSString* writeableDatabasePath = [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
	return writeableDatabasePath;
}

- (void) upgradeDatabase:(int)oldVersion newVersion:(int)version {
	NSLog(@"upgrading database from %i to %i", oldVersion, version);
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

- (BOOL) isStopAddedToFavourites:(City*)city stop:(Stop*)stop {
	BOOL isAdded = NO;
	
	FMResultSet* rs = [database executeQuery:@"SELECT COUNT(*) FROM favourite_stops WHERE stop_id=? AND \
					   route_number=? AND route_direction=? AND city_code=? AND transport_type_code=? AND app_city_code=?",
	stop.stopId, 
	stop.route.number,
	stop.route.directionType,
	stop.route.city,
	city.code];
	
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

- (BOOL) isRouteAddedToFavourites:(City*)city route:(Route*)route {
	BOOL isAdded = NO;
	
	FMResultSet* rs = [database executeQuery:@"SELECT COUNT(*) FROM favourite_routes WHERE route_number=? AND city_code=? \
		AND transport_type_code=? AND app_city_code=?",
		route.number,
		route.city,
		route.transportType.code,
		city.code];
	
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

- (void) addRouteToFavourites:(City*)city route:(Route*)route {
	if(![self isRouteAddedToFavourites:city route:route]) {
		[database executeUpdate:@"INSERT INTO favourite_routes (route_number, city_code, transport_type_code, app_city_code) VALUES (?,?,?,?)", 
		 route.number,
		 route.city,
		 route.transportType.code,
		 city.code];
		
		if([database hadError]) {
			NSLog(@"error while adding route to favourites, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		}
	}
}

- (void) addStopToFavourites:(City*)city stop:(Stop*)stop {
	if(![self isStopAddedToFavourites:city stop:stop]) {
		
		[database executeUpdate:@"INSERT INTO favourite_stops (stop_id, city_code, transport_type_code, route_number, route_direction, app_city_code) \
		 VALUES(?,?,?,?,?,?)",
		 stop.stopId,
		 stop.route.city,
		 stop.route.transportType.code,
		 stop.route.number,
		 stop.route.directionType,
		 city.code];
		
		if([database hadError]) {
			NSLog(@"error while adding stop to favourites, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		}
	}
}

- (NSArray*) getFavouriteRoutes:(City*)city {
	NSMutableArray* favouriteRoutes = [[NSMutableArray alloc] init];
	
	FMResultSet* rs = [database executeQuery:@"SELECT transport_type_code, route_number, city_code \
					   FROM favourite_routes WHERE app_city_code=?",
	city.code];
	
	if([database hadError]) {
		NSLog(@"error while retrieving favourite routes, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		[favouriteRoutes release];
		return nil;
	}
	
	while ([rs next]) {
		TransportType* transportType = [TransportType getByCode:[rs stringForColumn:@"transport_type_code"]];
		
		Route* rawRoute = [[Route alloc] init];
		rawRoute.number = [rs stringForColumn:@"route_number"];
		rawRoute.transportType = transportType;
		rawRoute.city = [rs stringForColumn:@"city_code"];
		
		RouteService* routeService = [RouteService getInstance];
		Route* route = [routeService getFullRoute:rawRoute];
	    if(route == nil) {
			NSLog(@"could not obtain route: %@", rawRoute);
	    }
						   
		[favouriteRoutes addObject:route];
		[rawRoute release];
	}
	[rs close];
	return [favouriteRoutes autorelease];
}

- (NSArray*) getFavouriteStops:(City*)city {
	NSMutableArray* favouriteStops = [[NSMutableArray alloc] init];
	
	FMResultSet* rs = [database executeQuery:@"SELECT stop_id, route_number, route_direction, transport_type_code, city_code \
					 FROM favourite_stops WHERE app_city_code=?", city.code];
	
	if([database hadError]) {
		NSLog(@"error while retrieving favourite stops, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
		[favouriteStops release];
		return nil;
	}
	
	while ([rs next]) {
		NSString* stopId = [rs stringForColumn:@"stop_id"];
		NSString* routeNumber = [rs stringForColumn:@"route_number"];
		NSString* routeDirection = [rs stringForColumn:@"route_direction"];
		NSString* transportTypeCode = [rs stringForColumn:@"transport_type_code"];
		NSString* cityCode = [rs stringForColumn:@"city_code"];
		
		Route* rawRoute = [Route alloc];
		rawRoute.number = routeNumber;
		rawRoute.transportType = [TransportType getByCode:transportTypeCode];
		rawRoute.city = cityCode;
		rawRoute.directionType = routeDirection;
		
		RouteService* routeService = [RouteService getInstance];
		Route* route = [routeService getFullDirection:rawRoute];
		Stop* stop = [routeService getStop:stopId route:route];
		
		if(stop == nil) {
			NSLog(@"unable to find stop: %@", stop);
		}
		
		[favouriteStops addObject:stop];
		
		[rawRoute release];
	}
	[rs close];
	return [favouriteStops autorelease];
}

- (void) deleteFavouriteStop:(City*)city stop:(Stop*)stop {
	[database executeUpdate:@"DELETE FROM favourite_stops WHERE stop_id=? AND route_number=? AND route_direction=? AND transport_type_code=? AND app_city_code=?",
	 stop.stopId,
	 stop.route.number,
	 stop.route.directionType,
	 stop.route.transportType.code,
	 city.code];
	
	if([database hadError]) {
		NSLog(@"error while deleting favourite stop, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
	}
}

- (void) deleteFavouriteRoute:(City*)city route:(Route*)route {
	[database executeUpdate:@"DELETE FROM favourite_routes WHERE route_number=? AND city_code=? AND transport_type_code=? AND app_city_code=?",
	 route.number,
	 route.city,
	 route.transportType.code,
	 city.code];
	
	if([database hadError]) {
		NSLog(@"error while deleting favourite route, %d: %@", [database lastErrorCode], [database lastErrorMessage]);
	}
}

- (void)dealloc {
	[database release];
	[super dealloc];
}
@end
