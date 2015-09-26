//
//  PublicTransportAppDelegate.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PublicTransportViewController;

@interface PublicTransportAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow* window;
    UITabBarController* tabBarController;
	UINavigationController* routeNavigationController;
	UINavigationController* favouritesNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *routeNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *favouritesNavigationController;

- (void)registerDefaultsFromSettingsBundle;
@end

