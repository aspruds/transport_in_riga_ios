//
//  Stop.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Direction.h"

@interface Stop : NSObject {
	NSNumber *stopId;
	NSString *name;
	NSNumber *latitude;
	NSNumber *longitude;
	Direction* direction;
}

@property (nonatomic, retain) NSNumber* stopId;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSNumber* latitude;
@property (nonatomic, retain) NSNumber* longitude;
@property (nonatomic, retain) Direction* direction;

- (id)initWithName:sid name:(NSString*)n latitude:(NSNumber*)lat longitude:(NSNumber*)lon;
@end
