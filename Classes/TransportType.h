#import <Foundation/Foundation.h>

@interface TransportType : NSObject {
	NSString* code;
	NSString* title;
	NSString* titlePlural;
	NSString* iconName;
	int orderId;
}

@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* titlePlural;
@property (nonatomic, retain) NSString* iconName;
@property int orderId;

#define kBus @"bus"
#define kTrolleybus @"trol"
#define kTram @"tram"
#define kMinibus @"minibus"
#define kNightBus @"nightbus"
#define kRegionalBus @"regionalbus"
#define kCommercialBus @"commercialbus"
#define kInternationalBus @"internationalbus"
#define kDistantBus @"distantbus"
#define kTrain @"train"
#define kPlane @"plane"
#define kFerry @"ferry"
#define kSubway @"metro"
#define kFestal @"festal"


- (id)init:(NSString*)code title:(NSString*)title titlePlural:(NSString*)titlePlural
  iconName:(NSString*)iconName orderId:(int)orderId;
+ (TransportType*)getByCode:(NSString*)code;
@end
