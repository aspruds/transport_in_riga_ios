//
//  PreferencesService.m
//  PublicTransport
//
//  Created by Andris Spruds on 12/26/11.
//  Copyright 2011 none. All rights reserved.
//

#import "PreferencesService.h"
#import "City.h"

@implementation PreferencesService

+ (City*) getCurrentCity {
	return [City getByCode:kRiga];
}

+ (BOOL) getOnlyMainDirectionsSetting {
	BOOL onlyMainDirections = [[[NSUserDefaults standardUserDefaults] stringForKey:@"hide_alternative_routes_preference"] boolValue];
	return onlyMainDirections;
}
@end
