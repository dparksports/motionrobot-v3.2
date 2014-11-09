//
//  CMGyroData+MJGyroData.m
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "CMLogItem+MJLogItem.h"
#import "CMGyroData+MJGyroData.h"

@implementation CMGyroData (MJGyroData)

#pragma mark - MJSONProtocol

- (void)decompressString:(NSDictionary *)dictionary {
    // todo
}

- (NSString *)compressedString {
    NSString *string = [self millisecondString];
    return [NSString stringWithFormat:@"%@:%1.1f %1.1f %1.1f;",
            string,
            self.rotationRate.x,
            self.rotationRate.y,
            self.rotationRate.z];
}

- (void)dejsonify:(NSDictionary *)dictionary {
    // todo
}

- (NSDictionary*)jsonify {
    NSDictionary *dictionary = @{@"x": [NSString stringWithFormat:@"%1.3f",
                                        self.rotationRate.x],
                                 @"y": [NSString stringWithFormat:@"%1.3f",
                                        self.rotationRate.y],
                                 @"z": [NSString stringWithFormat:@"%1.3f",
                                        self.rotationRate.z],
                                 @"timestamp": @(self.timestamp)};
    return dictionary;
}

#pragma mark - description

- (NSString *)description{
    return [NSString stringWithFormat:@"x:%1.5f, y:%1.5f, z:%1.5f, timestamp:%@",
            self.rotationRate.x,
            self.rotationRate.y,
            self.rotationRate.z,
            [self timeDateShortStyleString]];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"x:%@, y:%@, z:%@, timestamp:%@",
            [@(self.rotationRate.x) stringValue],
            [@(self.rotationRate.y) stringValue],
            [@(self.rotationRate.z) stringValue],
            [self timeDateNoStyleString]];
}
@end
