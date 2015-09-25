//
//  Direction.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"

@interface Direction : NSObject {
	NSNumber* directionId;
	NSString* type;
	NSString* name;
	Route* route;
}

@property (nonatomic, retain) NSNumber* directionId;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) Route* route;

- (id)initWithName:(NSNumber*)did type:(NSString*)t name:(NSString*)n route:(Route*)r;

@end
