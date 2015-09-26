/*
static const int kStopId = 0;
static const int kLatitude = 1;
static const int kLongitude = 2;
static const int kStops = 3;
static const int kName = 4;
static const int kInfo = 5;
static const int kStreet = 6;
static const int kArea = 7;
static const int kCity = 8;
*/

typedef enum {
	STOP_ID,
	LATITUDE,
	LONGITUDE,
	STOPS,
	NAME,
	INFO,
	STREET,
	AREA,
	CITY
} kStopHeader;
#define kStopHeaderArray @"ID",@"Lat",@"Lng",@"Stops",@"Name",@"Info",@"Street",@"Area",@"City",nil

@interface StopHeader : NSObject {
}

+(NSString*) toString:(kStopHeader)enumVal;

@end