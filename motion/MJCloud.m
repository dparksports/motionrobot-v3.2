//
//  MJCloud.m
//  motion
//
//  Created by Dan Park on 11/7/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJSerialize.h"
#import "MJCloud.h"

@implementation MJCloud

+ (id)retrieveCollection{
    // todo
    return nil;
}

+ (void)uploadCollectionToCloud:(id)collection {
    NSData *data = [MJSerialize serializeJSONData:collection];
    NSLog(@"%s: [data length]:%lu, max/msg:%lu", __func__,
          (unsigned long)[data length], (unsigned long)32 * 1024);
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self sendStringToCloud:string];
}

+ (void)sendStringToCloud:(NSString *)string {
    NSLog(@"%s: string:%@", __func__, string);
    NSLog(@"%s: [string length]:%lu, max/msg:%lu", __func__,
          (unsigned long)[string length], (unsigned long)32 * 1024);
}
@end
