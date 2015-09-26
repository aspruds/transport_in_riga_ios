#import "TransportType.h"

@implementation TransportType

@synthesize code;
@synthesize title;
@synthesize titlePlural;
@synthesize iconName;
@synthesize orderId;

- (id)init:(NSString*)codeValue title:(NSString*)titleValue titlePlural:(NSString*)titlePluralValue
  iconName:(NSString*)iconNameValue orderId:(int)orderIdValue {
	self.code = codeValue;
	self.title = titleValue;
	self.titlePlural = titlePluralValue;
	self.iconName = iconNameValue;
	self.orderId = orderIdValue;
	return self;
}

-(NSString*) description {
	return [NSString stringWithFormat:@"TransportType (code=%@)", code];
}

+ (TransportType*)getByCode:(NSString*)code {
	TransportType* transportType = nil;
	
	if([code isEqualToString:kBus]) {
		transportType = [[TransportType alloc] init:kBus title:NSLocalizedString(@"Bus", @"Bus Singular)") 
										titlePlural:NSLocalizedString(@"Buses", @"Bus Transport Type (Plural)") 
										   iconName:@"ic_bus_favicon.png" orderId:1];
	}
	else if([code isEqualToString:kTrolleybus]) {
		transportType = [[TransportType alloc] init:kTrolleybus title:NSLocalizedString(@"Trolleybus", @"Trolleybus (Singular)") 
										titlePlural:NSLocalizedString(@"Trolleybuses", @"Trolleybus (Plural)") iconName:@"ic_trolleybus_favicon.png" orderId:2];
	}
	else if([code isEqualToString:kTram]) {
		transportType = [[TransportType alloc] init:kTram title:NSLocalizedString(@"Tram", @"Tram (Singular)") 
										titlePlural:NSLocalizedString(@"Trams", @"Tram Transport Type (Plural)") iconName:@"ic_tram_favicon.png" orderId:3];
	}
	else if([code isEqualToString:kMinibus]) {
		transportType = [[TransportType alloc] init:kMinibus title:NSLocalizedString(@"Minibus", @"Minibus (Singular)")
										titlePlural:NSLocalizedString(@"Minibuses", @"Minibus (Plural)") iconName:@"ic_bus_favicon.png" orderId:4];
	}
	else if([code isEqualToString:kNightBus]) {
		transportType = [[TransportType alloc] init:kNightBus title:NSLocalizedString(@"Night Bus", @"Nightbus (Singular)")
										titlePlural:NSLocalizedString(@"Nightbus", @"Nightbus (Plural)") iconName:@"ic_bus_favicon.png" orderId:5];
	}	
	else if([code isEqualToString:kRegionalBus]) {
		transportType = [[TransportType alloc] init:kRegionalBus title:NSLocalizedString(@"Regional Bus", @"Regional Bus (Singular)")
										titlePlural:NSLocalizedString(@"Regional Buses", @"Regional Bus (Plural)") iconName:@"ic_bus_favicon.png" orderId:5];
	}	
	else if([code isEqualToString:kCommercialBus]) {
		transportType = [[TransportType alloc] init:kCommercialBus title:NSLocalizedString(@"Commercial Bus", @"Commercial Bus (Singular)")
										titlePlural:NSLocalizedString(@"Commercial Buses", @"Commercial Bus (Plural)") iconName:@"ic_bus_favicon.png" orderId:6];
	}
	else if([code isEqualToString:kInternationalBus]) {
		transportType = [[TransportType alloc] init:kInternationalBus title:NSLocalizedString(@"International Bus", @"International Bus (Singular)")
										titlePlural:NSLocalizedString(@"International Buses", @"International Bus (Plural)") iconName:@"ic_bus_favicon.png" orderId:7];
	}	
	else if([code isEqualToString:kDistantBus]) {
		transportType = [[TransportType alloc] init:kDistantBus title:NSLocalizedString(@"Distant Bus", @"Distant Bus (Singular)")
										titlePlural:NSLocalizedString(@"Distant Buses", @"Distant Bus (Plural)") iconName:@"ic_bus_favicon.png" orderId:8];
	}	
	else if([code isEqualToString:kTrain]) {
		transportType = [[TransportType alloc] init:kTrain title:NSLocalizedString(@"Train", @"Train (Singular)")
										titlePlural:NSLocalizedString(@"Trains", @"Train (Plural)") iconName:@"ic_tram_favicon.png" orderId:9];
	}	
	else if([code isEqualToString:kPlane]) {
		transportType = [[TransportType alloc] init:kPlane title:NSLocalizedString(@"Plane", @"Plane (Singular)")
										titlePlural:NSLocalizedString(@"Planes", @"Plane (Plural)") iconName:@"ic_bus_favicon.png" orderId:10];
	}	
	else if([code isEqualToString:kFerry]) {
		transportType = [[TransportType alloc] init:kFerry title:NSLocalizedString(@"Ferry", @"Ferry (Singular)") 
										titlePlural:NSLocalizedString(@"Ferries", @"Ferry (Plural)") iconName:@"ic_bus_favicon.png" orderId:11];
	}
	else if([code isEqualToString:kSubway]) {
		transportType = [[TransportType alloc] init:kSubway title:NSLocalizedString(@"Subway", @"Subway (Singular)")
										titlePlural:NSLocalizedString(@"Subways", @"Subway (Plural)") iconName:@"ic_bus_favicon.png" orderId:12];
	}
	else if([code isEqualToString:kFestal]) {
		transportType = [[TransportType alloc] init:kFestal title:NSLocalizedString(@"Christmas Train", @"Christmas Train (Singular)")
										titlePlural:NSLocalizedString(@"Christmas Trains", @"Christramas Train (Plural)") iconName:@"ic_tram_favicon.png" orderId:13];
	}
	else {
		[[NSException exceptionWithName:@"unknownTransportTypeException" reason:@"Unknown transport type" userInfo:nil] raise];
		
	}
	return [transportType autorelease];
}

- (NSUInteger) hash {
	NSUInteger prime = 31;
	NSUInteger result = 1;
	
	return prime*result + [code hash];
}

-(BOOL) isEqual:(id)other {
	if(other == self) {
		return YES;
	}
	if(!other || ![other isKindOfClass:[self class]]) {
		return NO;
	}
	
	TransportType* otherTransportType = other;
	return [code isEqual:otherTransportType.code];
}

-(void)dealloc {
	[code release];
	[title release];
	[titlePlural release];
	[iconName release];
	[super dealloc];
}
@end
