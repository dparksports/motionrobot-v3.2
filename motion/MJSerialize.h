//
//  MJSerialize
//  motion
//
//  Created by Dan Park on 11/7/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJError.h"
@import Foundation;

@interface MJSerialize : NSObject

+ (id)deserializeJSONData:(NSString*)filename;
+ (NSData*)serializeJSONData:(id)collection;
@end
