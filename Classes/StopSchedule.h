//
//  StopSchedule.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StopSchedule : NSObject {
	NSNumber *stopScheduleId;
	NSNumber *timingId;
	NSNumber *hours;
	NSNumber *minutes;
	NSNumber *daysValid;
	NSNumber *lowfloor;
	NSNumber *shortened;
}

@property (nonatomic, retain) NSNumber* stopScheduleId;
@property (nonatomic, retain) NSNumber* timingId;
@property (nonatomic, retain) NSNumber* hours;
@property (nonatomic, retain) NSNumber* minutes;
@property (nonatomic, retain) NSNumber* daysValid;
@property (nonatomic, retain) NSNumber* lowfloor;
@property (nonatomic, retain) NSNumber* shortened;

- (id)init:sid timingId:(NSNumber*)tid hours:(NSNumber*)hrs 
   minutes:(NSNumber*)mins daysValid:(NSNumber*)valid lowfloor:(NSNumber*)isLow shortened:(NSNumber*)isShort;

@end
