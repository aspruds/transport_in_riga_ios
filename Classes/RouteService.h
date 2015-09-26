//
//  RouteService.h
//  PublicTransport
//
//  Created by Andris Spruds on 12/11/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "ScheduleData.h"
#import "RawSchedule.h"
#import "Route.h"
#import "Stop.h"
#import "TransportType.h"

@interface RouteService : NSObject {
	NSArray* parsedRoutes;
	NSArray* parsedStops;
}

@property (nonatomic, retain) NSArray* parsedRoutes;
@property (nonatomic, retain) NSArray* parsedStops;

+ (RouteService*) getInstance;
- (ScheduleData*) getScheduleData: (City*)city;
- (void) updateSchedules: (City*)city;
- (NSArray*) getTransportTypes;
- (Route*) getFullRoute: (Route*)incompleteRoute;
- (Route*) getFullDirection: (Route*)incompleteDirection;
- (NSArray*) getStopsByRoute: (Route*)route;
- (Stop*) getStop: (NSString*)stopId route:(Route*)route;
- (NSArray*) getRoutesByTransportType: (TransportType*)transportType;
- (NSArray*) getDirectionsByRoute: (Route*)route onlyMainDirections:(BOOL)onlyMainDirections;
- (Route*) findReverseDirection: (NSArray*)directions mainDirection:(Route*)mainDirection;
- (NSArray*) getDirectionsByRoute: (Route*)route;
- (NSArray*) getStopScheduleByStop: (Stop*)stop;
- (int) getDirectionTag: (NSString*)directionType;
- (RawSchedule*) explodeTimes: (NSString*) timesInput;
- (id) initWithCity: (City*)city;

@end
