//
//  MJMotionMeter.m
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "CMGyroData+MJGyroData.h"

#import "MJMotionMeter.h"

@interface MJMotionMeter () 
@property (nonatomic, strong) CMMotionManager *motionManager;
@end

@implementation MJMotionMeter

- (void)dealloc {
    [self setMotionManager:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        id instance = [CMMotionManager new];
        [self setMotionManager:instance];
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

#pragma mark - startGyroUpdatesToQueue

- (BOOL)checkGyroAvailableUI {
    static BOOL available = NO;
    if (! available) {
        available = [_motionManager isGyroAvailable];
        if (! available) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No Gyro Available is available"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return available;
}

- (void)stopGyroUpdates {
    if ([_motionManager isGyroActive])
        [_motionManager stopGyroUpdates];
}

- (void)startGyroUpdatesToQueue {
    [_motionManager setGyroUpdateInterval:1/1.0];
    [_motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
     ^(CMGyroData *gyroData, NSError *error)
     {
         if (error)
             [self handleErrorUI:error];
         else {
             if (self.delegate)
                 [self.delegate updateGyroData:gyroData];
         }
     }];
}

#pragma mark - startAccelerometerUpdatesToQueue

- (BOOL)checkAccelerometerAvailableUI {
    static BOOL available = NO;
    if (! available) {
        available = [_motionManager isAccelerometerAvailable];
        if (! available) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No Accelerometer Available is available"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return available;
}

- (void)stopAccelerometerUpdates {
    if ([_motionManager isAccelerometerActive])
        [_motionManager stopAccelerometerUpdates];
}

- (void)startAccelerometerUpdatesToQueue {
    [_motionManager setAccelerometerUpdateInterval:1/10.0];
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
     ^(CMAccelerometerData *accelerometerData, NSError *error)
    {
        if (error)
            [self handleErrorUI:error];
        else {
            if (self.delegate)
                [self.delegate updateAccelerometerData:accelerometerData];
        }
    }];
}

#pragma mark - CMError

- (void)handleErrorUI:(NSError *)error {
    NSLog(@"%s: Description:%@, RecoverySuggestion:%@, FailureReason:%@", __func__, [error localizedDescription], [error localizedRecoverySuggestion], [error localizedFailureReason]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[error localizedFailureReason]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
