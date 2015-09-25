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
	NSString *number;
	NSString *title;
	NSNumber *lowfloor;
	TransportType* transportType;
}

@property (nonatomic, retain) NSNumber *routeId;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *lowfloor;
@property (nonatomic, retain) TransportType* transportType;


- (id)initWithTitle:(NSNumber*)rid number:(NSString*)n title:(NSString*)ttl lowfloor:(NSNumber*)lf transportType:(TransportType*)typ;
@end
