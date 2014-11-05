//
//  CMAccelerometerData+MJAccelerometerData.m
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "CMLogItem+MJLogItem.h"
#import "CMAccelerometerData+MJAccelerometerData.h"

@implementation CMAccelerometerData (MJAccelerometerData)

- (NSString *)description{
    return [NSString stringWithFormat:@"x:%1.5f, y:%1.5f, z:%1.5f, timestamp:%@",
            self.acceleration.x,
            self.acceleration.y,
            self.acceleration.z,
            [self timestampShortString]];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"x:%@, y:%@, z:%@, timestamp:%@",
            [@(self.acceleration.x) stringValue],
            [@(self.acceleration.y) stringValue],
            [@(self.acceleration.z) stringValue],
            [self timestampString]];
}

@end
