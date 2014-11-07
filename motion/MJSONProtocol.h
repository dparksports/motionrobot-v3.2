//
//  MJSONProtocol.h
//  motion
//
//  Created by Dan Park on 11/7/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MJSONProtocol <NSObject>

- (void)dejsonify:(NSDictionary *)dictionary;
- (NSDictionary*)jsonify;
@end
