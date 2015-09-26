//
//  RouteParser.h
//  PublicTransport
//
//  Created by Andris Spruds on 12/13/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RawSchedule.h"
#import "RouteHeader.h"
#import "HeaderParser.h"

@interface RouteParser : NSObject {

}

+(NSString*) getValue:(NSArray*)scheduleData position:(kRouteHeader)pos header:(HeaderParser*)hdr;
+(BOOL) isEmpty:(NSString*)value;
+(void) parseComment:(NSMutableArray*)routes line:(NSString*)line;
+(int*) intListToArray:(NSMutableArray*)list;
+(RawSchedule*) explodeTimes:(NSString*)timesString;
+(NSMutableArray*) parseRoutes:(NSString*)data;
//+(NSString*) printArray:(int*)array size:(int)size;
@end
