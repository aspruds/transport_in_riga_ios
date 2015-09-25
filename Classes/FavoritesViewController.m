//
//  Favorites.m
//  PublicTransport
//
//  Created by Andris Spruds on 2/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavouriteStopsController.h"
#import "FavouriteRoutesController.h"

@implementation FavoritesViewController

@synthesize activeViewController;
@synthesize segmentedViewControllers;
@synthesize segmentedControl;

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSArray* segments = [NSArray arrayWithObjects:@"Routes", @"Stops", nil];
	
	UISegmentedControl* aSegmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
	[aSegmentedControl setFrame:CGRectMake(0, 0, 280, 30)];
	[aSegmentedControl setSelectedSegmentIndex:0];
	[aSegmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[aSegmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
	[aSegmentedControl addTarget:self action:@selector(onViewSwitched:) forControlEvents:UIControlEventValueChanged];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[[self navigationItem] setTitleView:aSegmentedControl];
	self.segmentedControl = aSegmentedControl;
	[aSegmentedControl release];
	
	// init views
	UIViewController* favouriteRoutesController = [[FavouriteRoutesController alloc] initWithNibName:@"FavouriteRoutesView" bundle:nil];
	UIViewController* favouriteStopsController = [[FavouriteStopsController alloc] initWithNibName:@"FavouriteStopsView" bundle:nil];
	self.segmentedViewControllers = [NSArray arrayWithObjects:favouriteRoutesController,favouriteStopsController,nil];
	
	[favouriteRoutesController release];
	[favouriteStopsController release];
	
	[self onViewSwitched:aSegmentedControl];
}
	
	
- (IBAction) onViewSwitched:(id)sender {
	if(activeViewController) {
		[activeViewController viewWillAppear:NO];
		[activeViewController.view removeFromSuperview];
		[activeViewController viewDidDisappear:NO];
	}
	
	activeViewController = [segmentedViewControllers objectAtIndex:[segmentedControl selectedSegmentIndex]];
	[activeViewController viewWillAppear:NO];
	[self.view addSubview:activeViewController.view];
	[activeViewController viewDidDisappear:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
	[super setEditing:editing animated:animate];
	
	if(activeViewController) {
		[activeViewController setEditing:editing animated:animate];
	}
	
	if(editing) {
		NSLog(@"Table edit mode on");
	}
	else {
		NSLog(@"Table edit mode off");
	}
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.activeViewController = nil;
	self.segmentedViewControllers = nil;	
}


- (void)dealloc {
    [super dealloc];
	[activeViewController release];
	[segmentedViewControllers release];
}


@end
