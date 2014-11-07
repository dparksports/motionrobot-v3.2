//
//  MJSerialize
//  motion
//
//  Created by Dan Park on 11/7/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJSerialize.h"

typedef NS_ENUM(NSUInteger, MJJSONWritingOptions) {
    MJJSONWritingCompact = 0,
    MJJSONWritingPrettyPrinted = NSJSONWritingPrettyPrinted,
};

@implementation MJSerialize

+ (NSData*)serializeJSONData:(id)collection {
    NSError *error = nil;
//    NSJSONWritingOptions options = (NSJSONWritingOptions) MJJSONWritingPrettyPrinted;
    NSJSONWritingOptions options = (NSJSONWritingOptions) MJJSONWritingCompact;
    NSData *data = [NSJSONSerialization dataWithJSONObject:collection options:options error:&error];
    if (error) {
        NSLog(@"%@", [MJError failureReasonAndDescriptionString:error]);
        return nil;
    }
    return data;
}

+ (id)deserializeJSONData:(NSString*)filename {
    NSError *error = nil;
    NSString *directory = nil;
    NSString *localization = nil;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:filename ofType:@"json" inDirectory:directory forLocalization:localization];
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"%@", [MJError failureReasonAndDescriptionString:error]);
        return nil;
    }
    
    NSJSONReadingOptions options = NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves;
    id tree = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
    if (error) {
        NSLog(@"%@", [MJError failureReasonAndDescriptionString:error]);
        return nil;
    }
    return tree;
}

@end
