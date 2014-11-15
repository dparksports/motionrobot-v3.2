//
//  CMDeviceMotion+MJDeviceMotion.h
//  motion
//
//  Created by Dan Park on 11/15/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJSONProtocol.h"
@import CoreMotion;

@interface CMDeviceMotion (MJDeviceMotion) <MJSONProtocol>

- (void)dejsonify:(NSDictionary *)dictionary;
- (NSDictionary*)jsonify;

- (NSString *)xDescription;
- (NSString *)description;
- (NSString *)debugDescription;
@end
