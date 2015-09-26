//
//  Stop.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"

@interface Stop : NSObject {
	NSString *stopId;
	NSNumber *latitude;
	NSNumber *longitude;
	NSString *stopsNearby;
	NSString *name;
	NSString *info;
	NSString *street;
	NSString *area;
	NSString *city;
	Route* route;
}

@property (nonatomic, retain) NSString* stopId;
@property (nonatomic, retain) NSNumber* latitude;
@property (nonatomic, retain) NSNumber* longitude;
@property (nonatomic, retain) NSString* stopsNearby;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* info;
@property (nonatomic, retain) NSString* street;
@property (nonatomic, retain) NSString* area;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) Route* route;

-(BOOL) isEqual:(id)other;

@end
