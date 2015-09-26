//
//  HeaderParser.h
//  PublicTransport
//
//  Created by Andris Spruds on 6/26/12.
//  Copyright 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HeaderParser : NSObject {
	NSDictionary* values;
}

@property (nonatomic, retain) NSDictionary* values;

-(id)init:(NSString*)headerLine;
-(int) getValue:(NSString*)code;

@end
