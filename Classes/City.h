//
//  City.h
//  PublicTransport
//
//  Created by Andris Spruds on 12/10/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface City : NSObject {
	NSString* code;
}

#define kRiga @"riga"
#define kVilnius @"vilnius"
#define kKaunas @"kaunas"
#define kKlaipeda @"klaipeda"
#define kLiepaja @"liepaja"
#define kTallinn @"tallinn"
#define kEstonia @"estonia"
#define kVologda @"vologda"
#define kMinsk @"minsk"
#define kDruskininkai @"druskininkai"
#define kChelyabinsk @"chelyabinsk"

@property (nonatomic, retain) NSString* code;

- (id)init:(NSString*)c;
+ (City*)getByCode:(NSString*)code;

@end
