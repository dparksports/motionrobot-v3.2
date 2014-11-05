//
//  CMMotionActivity+MJMotionActivity.m
//  motion
//
//  Created by Dan Park on 11/3/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "CMMotionActivity+MJMotionActivity.h"

@implementation CMMotionActivity (MJMotionActivity)

- (NSString *)activityTypeString {
    if (self.walking) {
        return @"Walking";
    } else if (self.running) {
        return @"Running";
    } else if (self.automotive) {
        return @"Automotive";
    } else if (self.stationary) {
        return @"Stationary";
    } else if (!self.unknown) {
        return @"Unknown";
    } else {
        return @"Unassigned";
    }
}

- (NSString *)activityTypeShortString {
    if (self.walking) {
        return @"Walk";
    } else if (self.running) {
        return @"Run";
    } else if (self.automotive) {
        return @"Auto";
    } else if (self.stationary) {
        return @"Station";
    } else if (!self.unknown) {
        return @"Unknown";
    } else {
        return @"Unassigned";
    }
}

- (NSString *)confidenceString {
    switch (self.confidence) {
        default:
            return @"Unassigned";
        case CMMotionActivityConfidenceLow:
            return @"Low";
        case CMMotionActivityConfidenceMedium:
            return @"Medium";
        case CMMotionActivityConfidenceHigh:
            return @"High";
    }
}

- (NSString *)confidenceLetter {
    switch (self.confidence) {
        default:
            return @"UN";
        case CMMotionActivityConfidenceLow:
            return @"L";
        case CMMotionActivityConfidenceMedium:
            return @"M";
        case CMMotionActivityConfidenceHigh:
            return @"H";
    }
}

- (NSString *)timestampString {
    NSString *startString = [NSDateFormatter localizedStringFromDate:self.startDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    return startString;
}

- (NSString *)description {
    NSString *confidenceString = [self confidenceString];
    NSString *activityTypeString = [self activityTypeString];
    return [NSString stringWithFormat:@"%@ %@",
            confidenceString, activityTypeString];
}

- (NSString *)debugDescription {
    NSString *confidenceString = [self confidenceString];
    NSString *activityTypeString = [self activityTypeString];
    NSString *startString = [self timestampString];

    return [NSString stringWithFormat:@"activity:%@, confidence:%@, start:%@",
            activityTypeString, confidenceString, startString ];
}
@end
