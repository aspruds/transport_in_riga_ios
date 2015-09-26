//
//  StopSchedulesViewController.m
//  PublicTransport
//
//  Created by Andris Spruds on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "StopSchedulesViewController.h"
#import "StopSchedule.h"
#import "RouteService.h"
#import "DatabaseManager.h"
#import "City.h"
#import "PreferencesService.h"
#import "DayTypes.h"
#import "NSStringExtensions.h"
#import "UIColorExtensions.h"

@implementation StopSchedulesViewController

@synthesize tableCell;
@synthesize tableHeader;
@synthesize stop;
@synthesize daySwitcher;
@synthesize stopSchedules;
@synthesize stopScheduleMap;
@synthesize currentDayType;
@synthesize dayTypes;
@synthesize nextDepartures;
@synthesize hud;

static const int kYes = 1;

static const int kCellHeight = 26;
static const int kHeaderHeight = 120;
static const int kHeaderTransportTypeTag = 1;
static const int kHeaderDirectionTag = 2;
static const int kHeaderStopTitleTag = 3;
static const int kHeaderNextDepartureOneTag = 4;
static const int kHeaderNextDepartureTwoTag = 5;
static const int kHeaderDaySwitcherTag = 6;

static const int kMinutesLabelTopMargin = 3;
static const int kMinutesLabelSpacer = 4;
static const int kMinutesFontSize = 15;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self setTitle:NSLocalizedString(@"Schedule", @"View title")];
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:hud];
	hud.labelText = NSLocalizedString(@"Loading...", @"Progress bar text");	
	[hud showWhileExecuting:@selector(loadSchedules) onTarget:self withObject:nil animated:YES];
	
	UIBarButtonItem* addToFavsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(onAddToFavouritesPressed:)];
	self.navigationItem.rightBarButtonItem = addToFavsButton;
	[addToFavsButton release];
	
	[super viewWillAppear:animated];
}

-(void) loadSchedules {
	RouteService* routeService = [RouteService getInstance];
	self.stopSchedules = [[routeService getStopScheduleByStop:stop] retain];
	
	[self buildStopScheduleMap];
	[self calculateDayTypes];
	[self updateHeader];
	
	[self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:YES];
}

-(void) updateTable {
	
	[self.tableView reloadData];
}

-(void)buildStopScheduleMap {
	NSMutableDictionary *aStopScheduleMap = [[NSMutableDictionary alloc] init];
	for(StopSchedule* schedule in stopSchedules) {
		
		if([schedule.daysValid intValue] == currentDayType) {
			NSMutableArray* stopSchedulesForHour = [aStopScheduleMap objectForKey:schedule.hours];
			
			if(stopSchedulesForHour == nil) {
				stopSchedulesForHour = [[NSMutableArray alloc] initWithObjects:schedule, nil];
				[aStopScheduleMap setObject:stopSchedulesForHour forKey:schedule.hours];
				[stopSchedulesForHour release];
			}
			else {
				[stopSchedulesForHour addObject:schedule];
			}
		}
	}
	
	self.stopScheduleMap = aStopScheduleMap;
	[aStopScheduleMap release];
}

- (void)addDaySwitchers {
	[daySwitcher removeAllSegments];

	NSString* currentDay = [NSString stringWithFormat:@"%d", [self getDayOfWeek]];
	
	int segmentIndex = 0;
	for(NSNumber* dayType in dayTypes) {
		NSString* title = nil;
		
		switch([dayType intValue]) {
			case kMonday:
				title = NSLocalizedString(@"Monday", @"Text for day type switcher");
				break;
			case kTuesday:
				title = NSLocalizedString(@"Tuesday", @"Text for day type switcher");
				break;
			case kWednesday:
				title = NSLocalizedString(@"Wednesday", @"Text for day type switcher");
				break;
			case kThursday:
				title = NSLocalizedString(@"Thursday", @"Text for day type switcher");
				break;
			case kFriday:
				title = NSLocalizedString(@"Friday", @"Text for day type switcher");
				break;
			case kSaturday:
				title = NSLocalizedString(@"Saturday", @"Text for day type switcher");
				break;
			case kSunday:
				title = NSLocalizedString(@"Sunday", @"Text for day type switcher");
				break;
			case kMondayFriday:
				title = NSLocalizedString(@"Workdays", @"Text for day type switcher");
				break;
			case kMondayFridaySaturday:
				title = NSLocalizedString(@"Workdays, Saturday", @"Text for day type switcher");
				break;
			case kFridaySaturday:
				title = NSLocalizedString(@"Fri-Sat", @"Text for day type switcher");
				break;
			case kSaturdaySunday:
				title = NSLocalizedString(@"Weekends", @"Text for day type switcher");
				break;
			case kEveryDay:
				title = NSLocalizedString(@"Every day", @"Text for day type switcher");
				break;
			case kWorkdaysSundaysHolidays:
				title = NSLocalizedString(@"Workdays, Sundays", @"Text for day type switcher");
				break;				
			default:
				break;
		}
		
		// add switcher
		[daySwitcher insertSegmentWithTitle:title atIndex:segmentIndex animated:NO];	
		
		NSString* daysValid = [NSString stringWithFormat:@"%@", dayType];
		// set selected if should be selected
		if([daysValid indexOf:currentDay] != -1) {
			daySwitcher.selectedSegmentIndex = segmentIndex;
			self.currentDayType = [dayType intValue];
		}

		segmentIndex++;
	}
}

- (int)getDayOfWeek {
	int dayOfWeek = 1;
	NSDate* today = [NSDate date];
	
	NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents* weekdayComponents = [cal components:NSWeekdayCalendarUnit fromDate:today];
	int day = [weekdayComponents weekday];
	[cal release];

	switch(day) {
		case 1:
			dayOfWeek = 7;
			break;
		case 2:
			dayOfWeek = 1;
			break;
		case 3:
			dayOfWeek = 2;
			break;
		case 4:
			dayOfWeek = 3;
			break;
		case 5:
			dayOfWeek = 4;
			break;
		case 6:
			dayOfWeek = 5;
			break;
		case 7:
			dayOfWeek = 6;
			break;
		default:
			dayOfWeek = 1;
			break;
	}
	
	return dayOfWeek;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [stopScheduleMap count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
		cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	static NSString* cellIdentifier = @"StopScheduleCellIdentifier";
	
	UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier];
	[cell setUserInteractionEnabled:NO];
	cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	cell.backgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	
	// add hours label
	float left = 5;
	float lastRight = 0;
	
	NSUInteger row = [indexPath row];
	NSArray* keys = [[stopScheduleMap allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSNumber* hours = [keys objectAtIndex:row];
	
	int hour = [hours intValue];
	if(hour > 23) {
		hour = hour % 24;
	}
	
	UILabel* labelHours = [[UILabel alloc] init];
	labelHours.text = [NSString stringWithFormat:@"%d", hour];
	labelHours.font = [UIFont boldSystemFontOfSize:kMinutesFontSize];
	labelHours.textColor = [UIColor colorForScheduleEntryHours];
	labelHours.backgroundColor = [UIColor clearColor];

	CGSize size = [labelHours.text sizeWithFont:labelHours.font constrainedToSize:CGSizeMake(9999, 9999)
								  lineBreakMode:labelHours.lineBreakMode];

	labelHours.frame = CGRectMake(5, kMinutesLabelTopMargin, size.width, size.height);		
	[cell addSubview:labelHours];
	[labelHours release];
	
	lastRight = left + size.width + kMinutesLabelSpacer;
	
	// add minutes labels
	NSArray* schedulesInHour = [[stopScheduleMap objectForKey:hours] retain];	
	for(StopSchedule* currentSchedule in schedulesInHour) {
		
		UILabel* labelMinutes = [[UILabel alloc] init];
		labelMinutes.text = [NSString stringWithFormat:@"%02d", [currentSchedule.minutes intValue]];
		labelMinutes.font = [UIFont systemFontOfSize:kMinutesFontSize];
		
		if([currentSchedule.shortened boolValue] == YES || [currentSchedule.changed boolValue] == YES) {
			labelMinutes.textColor = [UIColor colorForChangedScheduleEntry];
		}
		
		if([currentSchedule.lowfloor boolValue] == YES) {
			labelMinutes.backgroundColor = [UIColor colorForLowfloorScheduleEntry];
		}
		else {
			labelMinutes.backgroundColor = [UIColor clearColor];
		}
		
		CGSize size = [labelMinutes.text sizeWithFont:labelMinutes.font constrainedToSize:CGSizeMake(9999, 9999)
									  lineBreakMode:labelMinutes.lineBreakMode];
		
		labelMinutes.frame = CGRectMake(lastRight, kMinutesLabelTopMargin, size.width, size.height);
		[cell addSubview:labelMinutes];
		[labelMinutes release];
		
		lastRight = lastRight + size.width + kMinutesLabelSpacer;
	}
	[schedulesInHour release];
	return [cell autorelease];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	if(tableHeader == nil) {
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"StopSchedulesViewHeader" owner:self options:nil];
		if([nib count] < 1) {
			NSLog(@"Failed to load StopSchedulesViewHeader");
		}
		else {
			[self updateHeader];
		}
	}
	return tableHeader;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
	return kHeaderHeight;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	return kCellHeight;
}

- (void)updateHeader {
	[self addDaySwitchers];
	
	UILabel* transportTypeLabel = (UILabel*)[tableHeader viewWithTag:kHeaderTransportTypeTag];
	transportTypeLabel.text = 
	[[stop.route.transportType.title stringByAppendingString:@" "]
	 stringByAppendingString:stop.route.number];
	
	NSString* directionName = nil;
	NSArray* components = [stop.route.name componentsSeparatedByString:@"-"];
	if([components count] < 2) {
		directionName = stop.route.name;
	}
	else {
		directionName = [components objectAtIndex:1];
	}
	
	UILabel* directionLabel = (UILabel*)[tableHeader viewWithTag:kHeaderDirectionTag];
	directionLabel.text = directionName;
	
	UILabel* stopTitleLabel = (UILabel*)[tableHeader viewWithTag:kHeaderStopTitleTag];
	stopTitleLabel.text = stop.name;
	
	UILabel* nextDepartureOneLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureOneTag];
	nextDepartureOneLabel.text = NSLocalizedString(@"No Departures", @"Text label");
	
	UILabel* nextDepartureTwoLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureTwoTag];
	[nextDepartureTwoLabel setHidden:YES];
	
	[self calculateNextDepartures];
}

- (IBAction)dayTypeChanged:(id)sender {
	int selectedSegment = daySwitcher.selectedSegmentIndex;
	
	NSEnumerator * dayTypeEnum = [dayTypes objectEnumerator];
	NSNumber* dayType;
	int i=0;
	while(dayType = [dayTypeEnum nextObject]) {
		if(i++ == selectedSegment) {
			self.currentDayType = [dayType intValue];
			break;
		}
	}
	[self calculateNextDepartures];
	[self buildStopScheduleMap];
	[self.tableView reloadData];
}

- (void)calculateDayTypes {
	NSMutableSet* daySet = [[NSMutableSet alloc] init];
	for(StopSchedule* schedule in stopSchedules) {
		if(![daySet containsObject:schedule.daysValid]) {
			[daySet addObject:schedule.daysValid];
		}
	}
	self.dayTypes = daySet;
	[daySet release];
}

- (void)calculateNextDepartures {
	NSMutableArray* aNextDepartures = [[NSMutableArray alloc]init];
	NSMutableArray* scheduleDepartures = [[NSMutableArray alloc]init];
	NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	int daysAdded = 0;
	for(StopSchedule* schedule in stopSchedules) {
		if(([schedule.daysValid intValue]) == currentDayType) {
			unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
			
			NSDateComponents* timeComponents = [calendar components:unitFlags fromDate:[NSDate date]];
			int hour = [schedule.hours intValue];
			
			if(hour > 23) {
				hour = hour % 24;
				[timeComponents setDay:1];
			}
			[timeComponents setHour:hour];
			[timeComponents setMinute:[schedule.minutes intValue]];
			[timeComponents setSecond:0];

			NSDate* scheduleDate = [calendar dateFromComponents:timeComponents];
			if([scheduleDate compare:[NSDate date]] == NSOrderedDescending) {
				[aNextDepartures addObject:schedule];
				daysAdded++;
				if(daysAdded > 1) {
					break;
				}
			}
			
			[scheduleDepartures addObject:scheduleDate];
		}
	}
	
	int nextDepartureCount = [aNextDepartures count];
	if(nextDepartureCount == 0) {
		// set first to No Departures, hide second
		UILabel* nextDepartureOneLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureOneTag];
		nextDepartureOneLabel.text = NSLocalizedString(@"No Departures", @"Text label");
		
		UILabel* nextDepartureTwoLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureTwoTag];
		[nextDepartureTwoLabel setHidden:YES];
	}
	else if(nextDepartureCount == 1) {
		// set first value, hide second
		StopSchedule* nextDeparture = [aNextDepartures objectAtIndex:0];
		UILabel* nextDepartureOneLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureOneTag];
		nextDepartureOneLabel.text = [NSString stringWithFormat:@"%d:%02d", 
									  [nextDeparture.hours intValue], [nextDeparture.minutes intValue]];
		
		UILabel* nextDepartureTwoLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureTwoTag];
		[nextDepartureTwoLabel setHidden:YES];
	}
	else if(nextDepartureCount > 1) {
		// set both values
		// set first value, hide second
		StopSchedule* nextDeparture = [aNextDepartures objectAtIndex:0];
		UILabel* nextDepartureOneLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureOneTag];
		nextDepartureOneLabel.text = [NSString stringWithFormat:@"%d:%02d", 
									  [nextDeparture.hours intValue], [nextDeparture.minutes intValue]];
		
		StopSchedule* nextNextDeparture = [aNextDepartures objectAtIndex:1];
		UILabel* nextDepartureTwoLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureTwoTag];
		nextDepartureTwoLabel.text = [NSString stringWithFormat:@"%d:%02d",
									  [nextNextDeparture.hours intValue], [nextNextDeparture.minutes intValue]];
		[nextDepartureTwoLabel setHidden:NO];
	}
	
	self.nextDepartures = aNextDepartures;
	[calendar release];
	[scheduleDepartures release];
	[aNextDepartures release];
}

-(void) onAddToFavouritesPressed:(UIBarButtonItem*)sender {
	UIAlertView* alert = [[UIAlertView alloc] init];
	[alert setTitle:NSLocalizedString(@"Confirm", @"Dialog title")];
	[alert setMessage:NSLocalizedString(@"Add to favourites?", "Dialog prompt")];
	[alert setDelegate:self];
	[alert addButtonWithTitle:NSLocalizedString(@"No", "Button title")];
	[alert addButtonWithTitle:NSLocalizedString(@"Yes", "Button title")];	
	[alert show];
	[alert release];
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	City* city = [PreferencesService getCurrentCity];
	
	if (buttonIndex == kYes) {
		DatabaseManager* db = [[DatabaseManager alloc] init];
		[db open];
		[db addStopToFavourites:city stop:stop];
		[db close];
		[db release];
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.tableCell = nil;
	self.tableHeader = nil;
	self.stop  = nil;
	self.daySwitcher = nil;
	self.dayTypes = nil;
	self.nextDepartures = nil;
	self.stopSchedules = nil;
	self.stopScheduleMap = nil;
}

- (void)dealloc {
	[tableCell release];
	[tableHeader release];
	[stop release];
	[daySwitcher release];
	[dayTypes release];
	[nextDepartures release];
	[stopSchedules release];
	[stopScheduleMap release];
    [super dealloc];
}

@end
