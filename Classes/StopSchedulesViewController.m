//
//  StopSchedulesViewController.m
//  PublicTransport
//
//  Created by Andris Spruds on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import "StopSchedulesViewController.h"
#import "StopSchedule.h"
#import "DatabaseManager.h"

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

static const int kYes = 1;

static const int kCellHeight = 26;
static const int kHeaderHeight = 114;
static const int kHeaderTransportTypeTag = 1;
static const int kHeaderDirectionTag = 2;
static const int kHeaderStopTitleTag = 3;
static const int kHeaderNextDepartureOneTag = 4;
static const int kHeaderNextDepartureTwoTag = 5;
static const int kHeaderDaySwitcherTag = 6;

static const int kMinutesLabelTopMargin = 4;
static const int kMinutesLabelSpacer = 3;

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
	
	DatabaseManager* db = [[DatabaseManager alloc] init];
	[db open];
	self.stopSchedules = [db getStopSchedule:stop];
	[db close];
	[db release];
	
	[self buildStopScheduleMap];
	[self calculateDayTypes];
	[self calculateCurrentDayType];
	[self updateHeader];
	
	UIBarButtonItem* addToFavsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(onAddToFavouritesPressed:)];
	self.navigationItem.rightBarButtonItem = addToFavsButton;
	[addToFavsButton release];
	
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

-(void)buildStopScheduleMap {
	NSMutableDictionary *aStopScheduleMap = [[NSMutableDictionary alloc] init];
	NSEnumerator* en = [stopSchedules objectEnumerator];
	
	StopSchedule* schedule;
	while(schedule = [en nextObject]) {
		if(([schedule.daysValid intValue] & currentDayType) > 0) {
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

- (void)calculateCurrentDayType {
	int iCurrentDayType = 0;

	NSEnumerator * dayTypeEnum = [dayTypes objectEnumerator];
	
	NSNumber* dayType;
	while(dayType = [dayTypeEnum nextObject]) {
		int dayByteValue = [self getDayByteValue];
		if(([dayType intValue] & dayByteValue) > 0) {
			iCurrentDayType = [dayType intValue];
			break;
		}
	}
	self.currentDayType = iCurrentDayType;
}

- (void)addDaySwitchers {
	[daySwitcher removeAllSegments];

	NSEnumerator * dayTypeEnum = [dayTypes objectEnumerator];
	NSNumber* dayType;
	int i=0;
	while(dayType = [dayTypeEnum nextObject]) {
		NSString* title = nil;
		switch([dayType intValue]) {
			case 1:
				title = NSLocalizedString(@"Monday", @"Text for day type switcher");
				break;
			case 2:
				title = NSLocalizedString(@"Tuesday", @"Text for day type switcher");
				break;
			case 4:
				title = NSLocalizedString(@"Wednesday", @"Text for day type switcher");
				break;
			case 8:
				title = NSLocalizedString(@"Thursday", @"Text for day type switcher");
				break;
			case 16:
				title = NSLocalizedString(@"Friday", @"Text for day type switcher");
				break;
			case 32:
				title = NSLocalizedString(@"Saturday", @"Text for day type switcher");
				break;
			case 64:
				title = NSLocalizedString(@"Sunday", @"Text for day type switcher");
				break;
			case 31:
				title = NSLocalizedString(@"Workdays", @"Text for day type switcher");
				break;
			case 48:
				title = NSLocalizedString(@"Fri-Sat", @"Text for day type switcher");
				break;
			case 63:
				title = NSLocalizedString(@"Mon-Sat", @"Text for day type switcher");
				break;
			case 96:
				title = NSLocalizedString(@"Weekends", @"Text for day type switcher");
				break;
			case 127:
				title = NSLocalizedString(@"Every day", @"Text for day type switcher");
				break;
			default:
				break;
		}
		
		// add switcher
		[daySwitcher insertSegmentWithTitle:title atIndex:i animated:NO];	
		
		// set selected if should be selected
		if([dayType intValue] == self.currentDayType) {
			daySwitcher.selectedSegmentIndex = i;
		}

		i++;
	}
}

- (int)getDayByteValue {
	int dayByteValue = 0;
	NSDate* today = [NSDate date];
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"c"];
	
	int day = [[dateFormatter stringFromDate:today] intValue];
	[dateFormatter release];

	switch(day) {
		case 1:
			dayByteValue = 64;
			break;
		case 2:
			dayByteValue = 1;
			break;
		case 3:
			dayByteValue = 2;
			break;
		case 4:
			dayByteValue = 4;
			break;
		case 5:
			dayByteValue = 8;
			break;
		case 6:
			dayByteValue = 16;
			break;
		case 7:
			dayByteValue = 32;
			break;
		default:
			dayByteValue = 0;
			break;
	}
	
	return dayByteValue;
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
	
	UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	[cell setUserInteractionEnabled:NO];
	cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	cell.backgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	
	// add hours label
	float left = 5;
	float lastRight = 0;
	
	NSUInteger row = [indexPath row];
	NSArray* keys = [[stopScheduleMap allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSNumber* hours = [keys objectAtIndex:row];
	
	UILabel* labelHours = [[UILabel alloc] init];
	labelHours.text = [hours stringValue];
	labelHours.font = [UIFont boldSystemFontOfSize:13];
	labelHours.textColor = [UIColor colorWithRed:0/255.0 green:114/255.0 blue:187/255.0 alpha:1.0];
	labelHours.backgroundColor = [UIColor clearColor];

	CGSize size = [labelHours.text sizeWithFont:labelHours.font constrainedToSize:CGSizeMake(9999, 9999)
								  lineBreakMode:labelHours.lineBreakMode];

	labelHours.frame = CGRectMake(5, kMinutesLabelTopMargin, size.width, size.height);		
	[cell addSubview:labelHours];
	[labelHours release];
	
	lastRight = left + size.width + kMinutesLabelSpacer;
	
	// add minutes labels
	NSArray* schedulesInHour = [stopScheduleMap objectForKey:hours];
	StopSchedule* currentSchedule = nil;
	NSEnumerator* en = [schedulesInHour objectEnumerator];
	
	while(currentSchedule = [en nextObject]) {
		
		UILabel* labelMinutes = [[UILabel alloc] init];
		labelMinutes.text = [currentSchedule.minutes stringValue];
		labelMinutes.font = [UIFont systemFontOfSize:13];
		labelMinutes.backgroundColor = [UIColor clearColor];
		
		CGSize size = [labelMinutes.text sizeWithFont:labelMinutes.font constrainedToSize:CGSizeMake(9999, 9999)
									  lineBreakMode:labelMinutes.lineBreakMode];
		
		labelMinutes.frame = CGRectMake(lastRight, kMinutesLabelTopMargin, size.width, size.height);
		[cell addSubview:labelMinutes];
		[labelMinutes release];
		
		lastRight = lastRight + size.width + kMinutesLabelSpacer;
	}
	return cell;
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
	[[stop.direction.route.transportType.title stringByAppendingString:@" "]
	 stringByAppendingString:stop.direction.route.number];
	
	NSString* directionName = nil;
	NSArray* components = [stop.direction.name componentsSeparatedByString:@"-"];
	if([components count] < 2) {
		directionName = stop.direction.name;
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
	NSEnumerator* stopSchedulesEnum = [stopSchedules objectEnumerator];
	
	StopSchedule* schedule;
	while(schedule = [stopSchedulesEnum nextObject]) {
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
	NSEnumerator* en = [stopSchedules objectEnumerator];
	StopSchedule* schedule;
	while(schedule = [en nextObject]) {
		if(([schedule.daysValid intValue] & currentDayType) > 0) {
			unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
			
			NSDateComponents* timeComponents = [calendar components:unitFlags fromDate:[NSDate date]];
			[timeComponents setHour:[schedule.hours intValue]];
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
		nextDepartureOneLabel.text = [NSString stringWithFormat:@"%d:%d", 
									  [nextDeparture.hours intValue], [nextDeparture.minutes intValue]];
		
		UILabel* nextDepartureTwoLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureTwoTag];
		[nextDepartureTwoLabel setHidden:YES];
	}
	else if(nextDepartureCount > 1) {
		// set both values
		// set first value, hide second
		StopSchedule* nextDeparture = [aNextDepartures objectAtIndex:0];
		UILabel* nextDepartureOneLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureOneTag];
		nextDepartureOneLabel.text = [NSString stringWithFormat:@"%d:%d", 
									  [nextDeparture.hours intValue], [nextDeparture.minutes intValue]];
		
		StopSchedule* nextNextDeparture = [aNextDepartures objectAtIndex:1];
		UILabel* nextDepartureTwoLabel = (UILabel*)[tableHeader viewWithTag:kHeaderNextDepartureTwoTag];
		nextDepartureTwoLabel.text = [NSString stringWithFormat:@"%d:%d",
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
	[alert setTitle:@"Confirm"];
	[alert setMessage:@"Add to favourites?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
	[alert release];
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == kYes) {
		DatabaseManager* db = [[DatabaseManager alloc] init];
		[db open];
		[db addStopToFavourites:stop];
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
