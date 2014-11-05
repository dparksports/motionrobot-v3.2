//
//  MJTimeManager.m
//  motion
//
//  Created by Dan Park on 11/3/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJTimeKeeper.h"

@implementation MJTimeKeeper

+ (NSDate *)startActivityDate{
    static NSDate *startTime = nil;
    if (! startTime) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            startTime = [NSDate date];
        });
    }
    return startTime;
}

@end
