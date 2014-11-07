//
//  MJError
//  motion
//
//  Created by Dan Park on 11/7/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface MJError : NSObject
+ (NSString*)failureReasonAndDescriptionString:(NSError*)error;
@end
