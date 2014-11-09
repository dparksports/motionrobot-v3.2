//
//  CMLogItem+MJLogItem.m
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJTimeKeeper.h"
#import "CMLogItem+MJLogItem.h"

@implementation CMLogItem (MJLogItem)

- (NSDate *)bootTime {
    static NSDate *bootTime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"%s: self.timestamp:%@", __func__, @(self.timestamp));
        bootTime = [NSDate dateWithTimeIntervalSinceNow:-self.timestamp];
    });
    return bootTime;
}

- (NSString *)dateString{
    NSDateFormatter *dateFormatter = [MJTimeKeeper dateFormatter];
    [dateFormatter setDateFormat:@"MMddyy="];
    
    NSDate *bootTime = [self bootTime];
    NSDate *timestamp = [NSDate dateWithTimeInterval:self.timestamp sinceDate:bootTime];
    NSString *timestampString = [dateFormatter stringFromDate:timestamp];
    return timestampString;
}

- (NSString *)millisecondString{
    NSDateFormatter *dateFormatter = [MJTimeKeeper dateFormatter];
    [dateFormatter setDateFormat:@"HHmmss.S"];
    
    NSDate *bootTime = [self bootTime];
    NSDate *timestamp = [NSDate dateWithTimeInterval:self.timestamp sinceDate:bootTime];
    NSString *timestampString = [dateFormatter stringFromDate:timestamp];
    return timestampString;
}

- (NSString *)timeDateNoStyleString {
    NSDate *bootTime = [self bootTime];
    NSDate *timestamp = [NSDate dateWithTimeInterval:self.timestamp sinceDate:bootTime];
    
    NSString *timestampString = [NSDateFormatter localizedStringFromDate:timestamp dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    return timestampString;
}

- (NSString *)timeDateShortStyleString {
    NSDate *bootTime = [self bootTime];
    NSDate *timestamp = [NSDate dateWithTimeInterval:self.timestamp sinceDate:bootTime];
    
    NSString *timestampString = [NSDateFormatter localizedStringFromDate:timestamp dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    return timestampString;
}

@end
