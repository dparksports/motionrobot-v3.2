//
//  MJMotionManager.h
//  motion
//
//  Created by Dan Park on 11/2/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJMotionManager : NSObject
@property (nonatomic, readonly) NSMutableArray *movements;

+ (instancetype)sharedInstance;
+ (BOOL)checkActivityAvailableUI;
- (void)checkAuthorizationUI;

- (void)stopPedometerUpdates;
- (void)startPedometerUpdates;
@end
