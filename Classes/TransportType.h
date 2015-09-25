//
//  TransportType.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/28/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransportType : NSObject {
	NSNumber* transportTypeId;
	NSString* title;
}

@property (nonatomic, retain) NSNumber* transportTypeId;
@property (nonatomic, retain) NSString* title;

static const int kBus = 0;
static const int kTram = 1;
static const int kTrolleybus = 2;

- (id)initWithTitle:(NSNumber*)ttid title:(NSString*)t;
+ (TransportType*)transportTypeById:(int)typeId;
@end
