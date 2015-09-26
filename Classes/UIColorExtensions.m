//
//  UIColorExtensions.m
//  PublicTransport
//
//  Created by Andris Spruds on 1/9/12.
//  Copyright 2012 none. All rights reserved.
//

#import "UIColorExtensions.h"


@implementation UIColor (Transport)

+(UIColor*) colorForScheduleEntryHours {
	return [UIColor colorWithRed:0/255.0 green:114/255.0 blue:187/255.0 alpha:1.0];
}

+(UIColor*) colorForChangedScheduleEntry {
	return [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];	
}

+(UIColor*) colorForLowfloorScheduleEntry {
	return [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1.0];		
}

@end
