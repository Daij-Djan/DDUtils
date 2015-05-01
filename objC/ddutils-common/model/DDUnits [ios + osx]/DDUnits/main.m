//
//  main.m
//  DDUnits
//
//  Created by Dominik Pich on 10/02/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDUnits.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        DDUnitTypeDuration,    //in secs, shown as a timestring HH:MM:SS (if days > 0, DD:HH:MM:SS)
        id time1 = @( 60*60*24 + 60*60*5 + 60*5 + 10 );
        id time2 = [DDUnits valueForText:@"1:05:05:10" withUnitType:DDUnitTypeDuration];
        NSLog(@"%@ == %@ = %d ==> %@", time1, time2, [time1 isEqualToNumber:time2], [DDUnits valueTextWithUnitForValue:time2 unitType:DDUnitTypeDuration]);

//        DDUnitTypeSpeed,       //kmh, no fractions, floored to int
        id speed1 = @(KMH_TO_MPS(10.1));
        id speed2 = [DDUnits valueForText:[NSString stringWithFormat:@"10,1 %@", [DDUnits unitTextForUnitType:DDUnitTypeSpeed]] withUnitType:DDUnitTypeSpeed];
        NSLog(@"%@ == %@ = %d ==> %@", speed1, speed2, [speed1 isEqualToNumber:speed2], [DDUnits valueTextWithUnitForValue:speed2 unitType:DDUnitTypeSpeed]);
        
//        DDUnitTypeDistance,    //km, 2 fractions max, rounded
        id distance1 = @10.1;
        id distance2 = [DDUnits valueForText:[NSString stringWithFormat:@"10,1 %@", [DDUnits unitTextForUnitType:DDUnitTypeDistance]] withUnitType:DDUnitTypeDistance];
        NSLog(@"%@ == %@ = %d ==> %@", distance1, distance2, [distance1 isEqualToNumber:distance2], [DDUnits valueTextWithUnitForValue:distance2 unitType:DDUnitTypeDistance]);

//        DDUnitTypeHeight,      //m, floored to int
        id height1 = @10.1;
        id height2 = [DDUnits valueForText:[NSString stringWithFormat:@"10,1 %@", [DDUnits unitTextForUnitType:DDUnitTypeHeight]] withUnitType:DDUnitTypeHeight];
        NSLog(@"%@ == %@ = %d ==> %@", height1, height2, [height1 isEqualToNumber:height2], [DDUnits valueTextWithUnitForValue:height2 unitType:DDUnitTypeHeight]);
        
//        DDUnitTypeCurrency,    //locale based currency, 2 fractions max, rounded
        id currency1 = @10.1;
        id currency2 = [DDUnits valueForText:[NSString stringWithFormat:@"10,1 %@", [DDUnits unitTextForUnitType:DDUnitTypeCurrency]] withUnitType:DDUnitTypeCurrency];
        NSLog(@"%@ == %@ = %d ==> %@", currency1, currency2, [currency1 isEqualToNumber:currency2], [DDUnits valueTextWithUnitForValue:currency2 unitType:DDUnitTypeCurrency]);
        
//        DDUnitTypeLiquidVolume //l, 2 fractions max, rounded
        id liter1 = @10.1;
        id liter2 = [DDUnits valueForText:[NSString stringWithFormat:@"10,1 %@", [DDUnits unitTextForUnitType:DDUnitTypeLiquidVolume]] withUnitType:DDUnitTypeLiquidVolume];
        NSLog(@"%@ == %@ = %d ==> %@", liter1, liter2, [liter1 isEqualToNumber:liter2], [DDUnits valueTextWithUnitForValue:liter2 unitType:DDUnitTypeLiquidVolume]);
    }
    return 0;
}
