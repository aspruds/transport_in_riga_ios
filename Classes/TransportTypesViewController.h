//
//  PublicTransportViewController.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteNavigationController.h"
#import "RoutesViewController.h"

@interface TransportTypesViewController : UIViewController {
}

@property (nonatomic, retain) RoutesViewController *routesView;

- (IBAction)buttonPressed:(id)sender;
@end

