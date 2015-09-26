//
//  PreferencesService.h
//  PublicTransport
//
//  Created by Andris Spruds on 12/26/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface PreferencesService : NSObject {
}

+ (City*) getCurrentCity;
+ (BOOL) getOnlyMainDirectionsSetting;

@end
