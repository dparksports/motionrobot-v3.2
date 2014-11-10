//
//  MJPubnubProxy.h
//  motion
//
//  Created by Dan Park on 11/10/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import Foundation;

@interface MJPubnubProxy : NSObject <MJCloudProxyProtocol>

+ (instancetype)sharedInstance;

- (void)initializeCloudClient;
- (void)connectToCloud;
- (void)sendMessageToCloud:(NSString *)message;
@end
