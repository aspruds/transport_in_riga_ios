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
#import "City.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "RouteService.h"

@interface DatabaseManager : NSObject {
	FMDatabase* database;
}

@property (nonatomic, retain) FMDatabase* database;

- (void) open;
- (void) close;
- (void) openDatabase;
- (void) createDatabase;
- (void) upgradeDatabase:(int)oldVersion newVersion:(int)version;
- (NSString*) getDatabasePath;
- (int) getDatabaseVersion;
- (void) setDatabaseVersion:(int)newVersion;

- (BOOL) isStopAddedToFavourites:(City*)city stop:(Stop*)stop;
- (BOOL) isRouteAddedToFavourites:(City*)city route:(Route*)route;
- (void) addRouteToFavourites:(City*)city route:(Route*)route;
- (void) addStopToFavourites:(City*)city stop:(Stop*)stop;
- (NSArray*) getFavouriteRoutes:(City*)city;
- (NSArray*) getFavouriteStops:(City*)city;
- (void) deleteFavouriteStop:(City*)city stop:(Stop*)stop;
- (void) deleteFavouriteRoute:(City*)city route:(Route*)route;
@end
