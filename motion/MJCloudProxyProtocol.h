//
//  MJCloudProxyProtocol.h
//  motion
//
//  Created by Dan Park on 11/10/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import Foundation;

@protocol MJCloudProxyProtocol <NSObject>

- (void)initializeCloudClient;
- (void)connectToCloud;
- (void)sendMessageToCloud:(NSString *)message;
@end
