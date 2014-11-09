//
//  CMLogItem+MJLogItem.h
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import CoreMotion;

@interface CMLogItem (MJLogItem)

- (NSDate *)bootTime;

- (NSString *)dateString;
- (NSString *)millisecondString;
- (NSString *)timeDateNoStyleString;
- (NSString *)timeDateShortStyleString;
@end
