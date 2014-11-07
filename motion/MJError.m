//
//  MJError
//  motion
//
//  Created by Dan Park on 11/7/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJError.h"

@implementation MJError

+ (NSString*)failureReasonAndDescriptionString:(NSError*)error {
    return [NSString stringWithFormat:@"%@:reason[%@]:code:%ld",
            [error localizedDescription], [error localizedFailureReason], (long)[error code]];
}
@end