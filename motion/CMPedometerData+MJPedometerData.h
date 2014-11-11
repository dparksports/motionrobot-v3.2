//
//  CMPedometerData+MJPedometerData.h
//  motion
//
//  Created by Dan Park on 11/3/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import CoreMotion;

@interface CMPedometerData (MJPedometerData)

- (NSString *)timestampString;
- (NSString *)timestampShortString;

- (NSString *)description;
- (NSString *)debugDescription;

- (NSUInteger)unsignedNumberOfSteps;
- (NSUInteger)normalizedFractalDistance;

@end
