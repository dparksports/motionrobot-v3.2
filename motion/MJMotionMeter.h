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
- (void)updateMotionData:(CMDeviceMotion*)motionData sum:(double)deviceMotionSum;
- (void)updateGyroData:(CMGyroData*)gyroData;
- (void)updateAccelerometerData:(CMAccelerometerData*)accelerometerData;
@end

@interface MJMotionMeter : NSObject
@property (nonatomic, assign) id<MJMotionMeterDelegate> delegate;

+ (instancetype)sharedInstance;

// DeviceMotion
- (BOOL)checkDeviceMotionAvailableUI;
- (void)stopDeviceMotionUpdates;
- (void)startDeviceMotionUpdatesToQueue;
- (BOOL)isDeviceMotionActive;

// Gyro
- (BOOL)checkGyroAvailableUI;
- (void)stopGyroUpdates;
- (void)startGyroUpdatesToQueue;
- (BOOL)isGyroActive;

// Accelerometer
- (BOOL)checkAccelerometerAvailableUI;
- (void)stopAccelerometerUpdates;
- (void)startAccelerometerUpdatesToQueue;
- (BOOL)isAccelerometerActive;
@end
