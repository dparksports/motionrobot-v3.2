//
//  MJCloud.m
//  motion
//
//  Created by Dan Park on 11/7/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJSerialize.h"
#import "MJCloudProxyProtocol.h"
#import "MJPubnubProxy.h"
#import "MJCloud.h"

@interface MJCloud ()
@property (nonatomic, strong) id<MJCloudProxyProtocol> cloudProxy;
@end

@implementation MJCloud

- (void)dealloc {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        id<MJCloudProxyProtocol> proxy = [MJPubnubProxy sharedInstance];
        [self setCloudProxy:proxy];
        
        [_cloudProxy initializeCloudClient];
        [_cloudProxy connectToCloud];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    if (! sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [self.class new];
        });
    }
    return sharedInstance;
}

#pragma mark Cloud Commands

- (id)retrieveCollection{
    // todo
    return nil;
}

- (void)uploadCollectionToCloud:(id)collection {
    NSData *data = [MJSerialize serializeJSONData:collection];
    NSLog(@"%s: [data length]:%lu, max/msg:%lu", __func__,
          (unsigned long)[data length], (unsigned long)32 * 1024);
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self sendStringToCloud:string];
}

- (void)sendStringToCloud:(NSString *)string {
//    NSLog(@"%s: string:%@", __func__, string);
    if (_cloudProxy) {
        [_cloudProxy sendMessageToCloud:string];
        NSLog(@"%s: [string length]:%lu, max/msg:%lu", __func__,
              (unsigned long)[string length], (unsigned long)32 * 1024);
    }
}
@end
