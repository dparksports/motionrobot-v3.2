//
//  MJMotionManager.h
//  motion
//
//  Created by Dan Park on 11/2/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreMotion;
@interface MJPedoMeter : NSObject
@property (nonatomic, readonly) NSMutableArray *records;

+ (instancetype)sharedInstance;
+ (BOOL)checkPedometerAvailableUI;
- (void)checkAuthorizationUI;

- (void)stopPedometerUpdates;
- (void)startPedometerUpdates;
@end
