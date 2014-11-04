//
//  CMPedometerData+MJPedometerData.m
//  motion
//
//  Created by Dan Park on 11/3/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "CMPedometerData+MJPedometerData.h"

@implementation CMPedometerData (MJPedometerData)

- (NSString *)timestampString {
    NSLog(@"%s", __func__);
    
    NSString *startString = [NSDateFormatter localizedStringFromDate:self.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *endString = [NSDateFormatter localizedStringFromDate:self.endDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    
    return [NSString stringWithFormat:@"%@ - %@", startString, endString ];
}

- (NSString *)timestampShortString {
    NSLog(@"%s", __func__);
    
    NSString *endString = [NSDateFormatter localizedStringFromDate:self.endDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    
    return [NSString stringWithFormat:@"%@", endString ];
}


- (NSString *)description {
    NSLog(@"%s", __func__);
    
    return [NSString stringWithFormat:@"%lu steps, %lu ms, %lu asc, %lu des",
            [self.numberOfSteps longValue],
            [self.distance longValue],
            [self.floorsAscended longValue],
            [self.floorsDescended longValue]];
}

- (NSString *)debugDescription {
    NSLog(@"%s", __func__);
    
    NSString *startString = [NSDateFormatter localizedStringFromDate:self.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *endString = [NSDateFormatter localizedStringFromDate:self.endDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    
    return [NSString stringWithFormat:@"steps:%lu, distance:%lu(m), ascended:%lu, descended:%lu, start:%@, end:%@",
            [self.numberOfSteps longValue],
            [self.distance longValue],
            [self.floorsAscended longValue],
            [self.floorsDescended longValue],
            startString, endString ];
}

@end
