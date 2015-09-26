//
//  StopPinLocation.h
//  PublicTransport
//
//  Created by Andris Spruds on 12/31/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Stop.h"

@interface StopPinAnnotation : NSObject <MKAnnotation> {

}

@property (nonatomic, retain) Stop* stop;

-(id) initWithStop:(Stop*)stop;

@end
