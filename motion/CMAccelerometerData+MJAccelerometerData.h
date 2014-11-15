//
//  CMAccelerometerData+MJAccelerometerData.h
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJSONProtocol.h"
@import CoreMotion;

@interface CMAccelerometerData (MJAccelerometerData) <MJSONProtocol>

- (NSString *)description;
- (NSString *)debugDescription;

// MJSONProtocol
- (void)dejsonify:(NSDictionary *)dictionary;
- (NSDictionary*)jsonify;
- (void)decompressString:(NSDictionary *)dictionary;
- (NSString *)compressedString;
@end
