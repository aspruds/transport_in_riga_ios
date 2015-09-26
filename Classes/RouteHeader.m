//
//  RouteHeader.m
//  PublicTransport
//
//  Created by Andris Spruds on 6/21/12.
//  Copyright 2012 none. All rights reserved.
//

#import "RouteHeader.h"


@implementation RouteHeader

+(NSString*) toString:(kRouteHeader)enumVal {
	NSArray* kRouteHeaderArr = [[NSArray alloc] initWithObjects:kRouteHeaderArray];
	return [kRouteHeaderArr objectAtIndex:enumVal];
}

@end
