//
//  HeaderParser.m
//  PublicTransport
//
//  Created by Andris Spruds on 6/26/12.
//  Copyright 2012 none. All rights reserved.
//

#import "HeaderParser.h"


@implementation HeaderParser

@synthesize values;

-(id)init:(NSString*)headerLine {
	NSMutableDictionary* mValues = [[NSMutableDictionary alloc] init];
	NSLog(@"dict created");
	
	headerLine = [headerLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSLog(@"header line %@", headerLine);
	NSArray* lines = [[headerLine componentsSeparatedByString:@";"] retain];
	for(int i=0; i < [lines count]-1; i++) {
		NSString* line = [lines objectAtIndex:i];
		line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[mValues setObject:[NSNumber numberWithInteger:i] forKey:line];
	}
	self.values = [NSDictionary dictionaryWithDictionary:mValues];
	[mValues release];
	return self;
}

-(int) getValue:(NSString*)code {
	NSNumber* value = [values objectForKey:code];
	if(value == nil) {
		[NSException exceptionWithName:@"headerParserException" 
								reason:[NSString stringWithFormat:@"header not found: @s", code] userInfo:nil];
	}
	return [value intValue];
}

- (void)dealloc {
	[super dealloc];
	[values release];
}
@end
