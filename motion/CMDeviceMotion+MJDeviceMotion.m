//
//  CMDeviceMotion+MJDeviceMotion.m
//  motion
//
//  Created by Dan Park on 11/15/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "CMLogItem+MJLogItem.h"
#import "CMDeviceMotion+MJDeviceMotion.h"

@implementation CMDeviceMotion (MJDeviceMotion)

#pragma mark - MJSONProtocol

- (void)decompressString:(NSDictionary *)dictionary {
    // todo
}

- (NSString *)compressedString {
    NSString *string = [self millisecondString];
    return [NSString stringWithFormat:@"%@:%1.1f %1.1f %1.1f;",
            string,
            self.userAcceleration.x,
            self.userAcceleration.y,
            self.userAcceleration.z];
}

- (void)dejsonify:(NSDictionary *)dictionary {
    // todo
}

- (NSDictionary*)jsonify {
    NSDictionary *dictionary = @{@"x": [NSString stringWithFormat:@"%1.3f",
                                        self.userAcceleration.x],
                                 @"y": [NSString stringWithFormat:@"%1.3f",
                                        self.userAcceleration.y],
                                 @"z": [NSString stringWithFormat:@"%1.3f",
                                        self.userAcceleration.z],
                                 @"timestamp": @(self.timestamp)};
    return dictionary;
}

#pragma mark - description

- (NSString *)description{
    return [NSString stringWithFormat:@"x:%1.5f, y:%1.5f, z:%1.5f, timestamp:%@",
            self.userAcceleration.x,
            self.userAcceleration.y,
            self.userAcceleration.z,
            [self timeDateShortStyleString]];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"x:%@, y:%@, z:%@, timestamp:%@",
            [@(self.userAcceleration.x) stringValue],
            [@(self.userAcceleration.y) stringValue],
            [@(self.userAcceleration.z) stringValue],
            [self timeDateNoStyleString]];
}

@end
