//
//  CMPedometerData+MJPedometerData.m
//  motion
//
//  Created by Dan Park on 11/3/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "CMPedometerData+MJPedometerData.h"

@implementation CMPedometerData (MJPedometerData)


- (NSUInteger)unsignedNumberOfSteps {
    return [self.numberOfSteps unsignedIntegerValue];
}

- (NSUInteger)normalizedFractalDistance {
    float value = [self.distance floatValue];
    NSLog(@"%s: value:%lf", __func__, value);
    
    float normalizeFraction = value * 10;
    normalizeFraction = ceilf(normalizeFraction);
    NSUInteger fraction = (NSUInteger) normalizeFraction;
    return fraction;
}

- (NSString *)timestampShortString {
    NSLog(@"%s", __func__);
    
    NSString *endString = [NSDateFormatter localizedStringFromDate:self.endDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    return endString;
}

- (NSString *)timestampString {
    NSLog(@"%s", __func__);
    
    NSString *startString = [NSDateFormatter localizedStringFromDate:self.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *endString = [self timestampShortString];
    
    return [NSString stringWithFormat:@"%@ - %@", startString, endString ];
}

- (NSString *)description {
    NSLog(@"%s", __func__);
    
    return [NSString stringWithFormat:@"%lu Steps, %lu Meters, %lu Ascended, %lu Descended",
            [self.numberOfSteps longValue],
            [self.distance longValue],
            [self.floorsAscended longValue],
            [self.floorsDescended longValue]];
}

- (NSString *)debugDescription {
    NSLog(@"%s", __func__);
    
    NSString *startString = [NSDateFormatter localizedStringFromDate:self.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *endString = [self timestampShortString];
    
    return [NSString stringWithFormat:@"steps:%lu, distance:%lf(m), ascended:%lu, descended:%lu, start:%@, end:%@",
            [self.numberOfSteps longValue],
            [self.distance floatValue],
            [self.floorsAscended longValue],
            [self.floorsDescended longValue],
            startString, endString ];
}

@end
