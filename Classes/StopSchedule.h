//
//  StopSchedule.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"
#import "Stop.h"	

@interface StopSchedule : NSObject {
	Stop *stop;
	Route* route;
	NSNumber *hours;
	NSNumber *minutes;	
	NSNumber *daysValid;
	NSNumber *lowfloor;
	NSNumber *shortened;
	NSNumber *changed;
}

@property (nonatomic, retain) Stop* stop;
@property (nonatomic, retain) Route* route;
@property (nonatomic, retain) NSNumber* hours;
@property (nonatomic, retain) NSNumber* minutes;
@property (nonatomic, retain) NSNumber* daysValid;
@property (nonatomic, retain) NSNumber* lowfloor;
@property (nonatomic, retain) NSNumber* shortened;
@property (nonatomic, retain) NSNumber* changed;

- (id)init:st route:(Route*)rt hours:(NSNumber*)hrs 
   minutes:(NSNumber*)mins daysValid:(NSNumber*)valid lowfloor:(NSNumber*)isLow shortened:(NSNumber*)isShort changed:(NSNumber*)isChanged;

@end
