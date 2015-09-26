//
//  ScheduleData.h
//  PublicTransport
//
//  Created by Andris Spruds on 12/11/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ScheduleData : NSObject {
	NSString* routes;
	NSString* stops;
}

@property (nonatomic, retain) NSString* routes;
@property (nonatomic, retain) NSString* stops;

- (id)init:r stops:(NSString*)s;

@end
