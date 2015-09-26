//
//  RawSchedule.h
//  PublicTransport
//
//  Created by Andris Spruds on 12/11/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RawSchedule : NSObject {
	int* times;
	int timesSize;
	int* tags;
	int tagsSize;
	int* validFrom;
	int* validTo;
	int* workdays;
}

@property int* times;
@property int timesSize;

@property int* tags;
@property int tagsSize;
@property int* validFrom;
@property int* validTo;
@property int* workdays;

@end
