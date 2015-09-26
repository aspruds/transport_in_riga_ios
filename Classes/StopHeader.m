#import "StopHeader.h"

@implementation StopHeader

+(NSString*) toString:(kStopHeader)enumVal {
	NSArray* kStopHeaderArr = [[NSArray alloc] initWithObjects:kStopHeaderArray];
	return [kStopHeaderArr objectAtIndex:enumVal];
}
@end
