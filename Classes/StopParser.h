//
//  StopParser.h
//  PublicTransport
//
//  Created by Andris Spruds on 12/11/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderParser.h"
#import "StopHeader.h"

@interface StopParser : NSObject {
}

+(NSString*) getValue:(NSArray*)scheduleData position:(kStopHeader)pos header:(HeaderParser*)hdr;
+(BOOL) isEmpty:(NSString*)value;
+(NSMutableArray*) parseStops:(NSString*)data;

@end
