//
//  Route.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportType.h"

@interface Route : NSObject {
	NSNumber *routeId;
	NSString *authority;
	NSString *city;
	TransportType* transportType;
	NSString *operator;
	NSString *specialDates;
	NSString *weekdays;
	NSString *validityPeriods;
	NSString *number;
	NSString *name;
	NSString *directionType;
	NSString *routeTag;
	NSString *stops;
	NSString *times;
	NSString *commercial;
	NSNumber *order;
}

@property (nonatomic, retain) NSNumber *routeId;
@property (nonatomic, retain) NSString *authority;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) TransportType* transportType;
@property (nonatomic, retain) NSString *operator;
@property (nonatomic, retain) NSString *specialDates;
@property (nonatomic, retain) NSString *weekdays;
@property (nonatomic, retain) NSString *validityPeriods;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *directionType;
@property (nonatomic, retain) NSString *routeTag;
@property (nonatomic, retain) NSString *stops;
@property (nonatomic, retain) NSString *times;
@property (nonatomic, retain) NSString *commercial;
@property (nonatomic, retain) NSNumber *order;

@end
