//
//  DatabaseManager.h
//  PublicTransport
//
//  Created by Andris Spruds on 3/21/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportType.h"
#import "Route.h"
#import "Direction.h"
#import "Stop.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface DatabaseManager : NSObject {
	FMDatabase* database;
}

@property (nonatomic, retain) FMDatabase* database;

- (void) open;
- (void) close;
- (void) openDatabase;
- (void) copyDatabase;
- (void) deleteDatabase;
- (void) upgradeDatabase:(int)oldVersion newVersion:(int)version;
- (NSString*) getDatabasePath;
- (int) getDatabaseVersion;
- (void) setDatabaseVersion:(int)newVersion;

- (NSArray*) getRoutesByTransportType:(TransportType*)transportType;
- (NSArray*) getDirectionsByRoute:(Route*)route;
- (NSArray*) getStopsByDirection:(Direction*)direction;
- (NSArray*) getStopSchedule:(Stop*)stop;
- (BOOL) isStopAddedToFavourites:(Stop*)stop;
- (BOOL) isRouteAddedToFavourites:(Route*)route;
- (void) addRouteToFavourites:(Route*)route;
- (void) addStopToFavourites:(Stop*)stop;
- (NSArray*) getFavouriteRoutes;
- (NSArray*) getFavouriteStops;
- (void) deleteFavouriteStop:(Stop*)stop;
- (void) deleteFavouriteRoute:(Route*)route;
@end
