//
//  ExtendNSString.m
//  PublicTransport
//
//  Created by Andris Spruds on 12/25/11.
//  Copyright 2011 none. All rights reserved.
//

#import "NSStringExtensions.h"


@implementation NSString (util) 
	-(int) indexOf:(NSString*) text {
		NSRange range = [self rangeOfString:text];
		if(range.length > 0) {
			return range.location;
		}
		else {
			return -1;
		}
	}
@end
