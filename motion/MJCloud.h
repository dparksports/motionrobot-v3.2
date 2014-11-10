//
//  MJCloud.h
//  motion
//
//  Created by Dan Park on 11/7/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import Foundation;

@interface MJCloud : NSObject

+ (instancetype)sharedInstance;

- (id)retrieveCollection;
- (void)uploadCollectionToCloud:(id)collection;
- (void)sendStringToCloud:(NSString *)string;
@end
