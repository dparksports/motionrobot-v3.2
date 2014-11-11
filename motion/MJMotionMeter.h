//
//  MJMotionMeter.h
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreMotion;

@protocol MJMotionMeterDelegate <NSObject>
- (void)updateGyroData:(CMGyroData*)gyroData;
- (void)updateAccelerometerData:(CMAccelerometerData*)accelerometerData;
@end

@interface MJMotionMeter : NSObject
@property (nonatomic, assign) id<MJMotionMeterDelegate> delegate;

+ (instancetype)sharedInstance;

// Gyro
- (BOOL)checkGyroAvailableUI;
- (void)stopGyroUpdates;
- (void)startGyroUpdatesToQueue;

// Accelerometer
- (BOOL)checkAccelerometerAvailableUI;
- (void)stopAccelerometerUpdates;
- (void)startAccelerometerUpdatesToQueue;
- (BOOL)isAccelerometerActive;
@end
