/**
@file      DDUnits.h
@author    Dominik Pich
@date      2014-03-27
*/
#import <Foundation/Foundation.h>

//this isnt 100% complete but a template for unit handling! (and all I needed so far ;))

typedef enum {
	DDUnitTypeNone = 0,
    DDUnitTypeDuration,    //in secs, shown as a timestring HH:MM:SS (if days > 0, DD:HH:MM:SS)
    DDUnitTypeSpeed,       //kmh, no fractions, floored to int
    DDUnitTypeDistance,    //km, 2 fractions max, rounded
    DDUnitTypeHeight,      //m, no fractions, floored to int
    DDUnitTypeCurrency,    //locale based currency, 2 fractions max, rounded
    DDUnitTypeLiquidVolume //l, 2 fractions max, rounded
} DDUnitType;

@interface DDUnits : NSObject

+ (NSString*)unitTextForUnitType:(DDUnitType)unitType;

//never negative
+ (NSString*)regExPatternForUnitType:(DDUnitType)unitType;

//no unit string is attached
+ (NSString*)valueTextWithoutUnitForValue:(NSNumber*)value withUnitType:(DDUnitType)unitType;

//number + ' unit'
+ (NSString*)valueTextWithUnitForValue:(NSNumber*)value unitType:(DDUnitType)unitType;

//All distance related values are returned in meter
//for the 'decimal separator' the current locale is assumed
+ (NSNumber*)valueForText:(NSString*)text withUnitType:(DDUnitType)unitType;

@end

#pragma mark -
#pragma mark Speed conversions

#define MPS_TO_KMH(x) 	((x)*3.6)
#define KMH_TO_MPS(x)	((x)/3.6)

#define KTS_TO_KMH(x)	((x)*1.852)
#define KMH_TO_KTS(x)	((x)/1.852)

#define KTS_TO_MPS(x)	((x)*0.5144)
#define MPS_TO_KTS(x)	((x)*1.9438)

#define MPH_TO_KTS(x)	((x)*0.869)
#define KTS_TO_MPH(x)	((x)*1.151)

#define MPH_TO_KMH(x)   ((x)*1.609)
#define KMH_TO_MPH(x)   ((x)*0.621)

#pragma mark -
#pragma mark Length/Distance conversions

#define METER_TO_YRD(x)     ((x)*1.0936133)
#define YRD_TO_METER(x)     ((x)*0.9144)

#define FEET_TO_METER(x) 	((x)*0.3048)
#define METER_TO_FEET(x) 	((x)*3.2808)

#define KM_TO_METER(x)		((x)*1000)
#define METER_TO_KM(x)		((x)*0.001)

#define MIL_TO_KM(x)        ((x)*1.609)
#define KM_TO_MIL(x)        ((x)*0.621)

#pragma mark -
#pragma mark Temperature conversions

#define C_TO_F(x)			((x) *9.0/5.0 + 32) 
#define F_TO_C(x)			(((x) - 32) * 5.0/9.0)
#define K_TO_C(x)			((x) - 273.15)


