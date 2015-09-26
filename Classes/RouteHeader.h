#import <Foundation/Foundation.h>

/*
static const int kRouteNum = 0;
static const int kAuthority = 1;
static const int kCity = 2;
static const int kTransport = 3;
static const int kOperator = 4;
static const int kValidityPeriods = 5;
static const int kSpecialDates = 6;
static const int kRouteTag = 7;
static const int kRouteType = 8;
static const int kCommercial = 9;
static const int kRouteName = 10;
static const int kWeekdays = 11;
static const int kRouteStops = 12;
*/
 
typedef enum {
	ROUTE_NUM,
	AUTHORITY,
	ROUTE_CITY,
	TRANSPORT,
	OPERATOR,
	VALIDITY_PERIODS,
	SPECIAL_DATES,
	ROUTE_TAG,
	ROUTE_TYPE,
	COMMERCIAL,
	ROUTE_NAME,
	WEEKDAYS,
	ROUTE_STOPS
} kRouteHeader;
#define kRouteHeaderArray @"RouteNum",@"Authority",@"City",@"Transport",@"Operator",@"ValidityPeriods",@"SpecialDates",@"RouteTag",@"RouteType",@"Commercial",@"RouteName",@"Weekdays",@"RouteStops",nil

@interface RouteHeader : NSObject {
}

+(NSString*) toString:(kRouteHeader)enumVal;

@end
