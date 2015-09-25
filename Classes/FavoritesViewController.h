//
//  Favorites.h
//  PublicTransport
//
//  Created by Andris Spruds on 2/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FavoritesViewController : UIViewController {
	UIViewController* activeViewController;
	NSArray* segmentedViewControllers;
	UISegmentedControl* segmentedControl;
}

@property (nonatomic, retain) UIViewController* activeViewController;
@property (nonatomic, retain) NSArray* segmentedViewControllers;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;

- (IBAction) onViewSwitched:(id)sender;
@end
