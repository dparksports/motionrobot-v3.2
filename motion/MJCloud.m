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
    NSLog(@"%s", __func__);
    
    NSData *data = [MJSerialize serializeJSONData:collection];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self sendStringToCloud:string];
}

+ (void)sendStringToCloud:(NSString *)string {
    NSLog(@"%s: string:%@", __func__, string);
}
@end
