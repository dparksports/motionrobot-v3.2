//
//  MJMotionMeter.m
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJCloud.h"
#import "CMLogItem+MJLogItem.h"
#import "CMGyroData+MJGyroData.h"
#import "CMAccelerometerData+MJAccelerometerData.h"

#import "MJMotionMeter.h"

@interface MJMotionMeter () 
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSMutableArray *accelerationRecords;
@property (nonatomic, strong) NSMutableArray *gyroRecords;
@property (nonatomic, strong) NSMutableArray *deviceMotionRecords;
@property (nonatomic, strong) dispatch_queue_t cloudQueue;
@property (nonatomic, strong) NSOperationQueue *deviceMotionQueue;
@end

@implementation MJMotionMeter {
    NSUInteger accelerometerDataCapacity;
    NSUInteger gyroDataCapacity;
    NSUInteger deviceMotionDataCapacity;
    NSUInteger networkBufferCapacity;
}

- (void)dealloc {
    [self setMotionManager:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // pubnub limit: 32KB/message
        networkBufferCapacity = 32 * 1024;
        accelerometerDataCapacity = 1100;//1200:404
        deviceMotionDataCapacity = 1100;
        gyroDataCapacity = 1100;
        
        id instance = nil;
        instance = [CMMotionManager new];
        [self setMotionManager:instance];

        dispatch_queue_t queue = dispatch_queue_create("mj.cloudQueue", DISPATCH_QUEUE_SERIAL);
        [self setCloudQueue:queue];
        
        NSOperationQueue *operationQueue = [NSOperationQueue new];
        [operationQueue setMaxConcurrentOperationCount:1];
        [self setDeviceMotionQueue:operationQueue];
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

- (BOOL)checkDeviceMotionAvailableUI {
    static BOOL available = NO;
    if (! available) {
        available = [_motionManager isDeviceMotionAvailable];
        if (! available) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No Device Motion Available is available"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return available;
}

- (BOOL)isDeviceMotionActive {
    return [_motionManager isDeviceMotionActive];
}

- (void)stopDeviceMotionUpdates {
    if ([_motionManager isDeviceMotionActive])
        [_motionManager stopDeviceMotionUpdates];
}

- (void)startDeviceMotionUpdatesToQueue {
    if (! _deviceMotionRecords) {
        id instance = [[NSMutableArray alloc] initWithCapacity:deviceMotionDataCapacity];
        [self setDeviceMotionRecords:instance];
    }
    
    [_motionManager setDeviceMotionUpdateInterval:1/8.0];  // 1/10.0
    [_motionManager startDeviceMotionUpdatesToQueue:_deviceMotionQueue withHandler:
     ^(CMDeviceMotion *motion, NSError *error)
     {
         if (error)
             [self handleErrorUI:error];
         else {
             if (self.delegate)
                 [self.delegate updateMotionData:motion];
         }
     }];
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
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return available;
}

- (BOOL)isGyroActive {
    return [_motionManager isGyroActive];
}

- (void)stopGyroUpdates {
    if ([_motionManager isGyroActive])
        [_motionManager stopGyroUpdates];
}

- (void)startGyroUpdatesToQueue {
    if (! _gyroRecords) {
        id instance = [[NSMutableArray alloc] initWithCapacity:gyroDataCapacity];
        [self setGyroRecords:instance];
//        [MJCloud sharedInstance];
    }

    [_motionManager setGyroUpdateInterval:1/10.0]; 
    [_motionManager startGyroUpdatesToQueue:_deviceMotionQueue withHandler:
     ^(CMGyroData *gyroData, NSError *error)
     {
         if (error)
             [self handleErrorUI:error];
         else {
             if (self.delegate)
                 [self.delegate updateGyroData:gyroData];
             dispatch_async(self.cloudQueue, ^{
                 [self compressGyroData:gyroData];
             });
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
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return available;
}

- (BOOL)isAccelerometerActive {
    return [_motionManager isAccelerometerActive];
}

- (void)stopAccelerometerUpdates {
    if ([_motionManager isAccelerometerActive])
        [_motionManager stopAccelerometerUpdates];
}

- (void)startAccelerometerUpdatesToQueue {
    if (! _accelerationRecords) {
        id instance = [[NSMutableArray alloc] initWithCapacity:accelerometerDataCapacity];
        [self setAccelerationRecords:instance];
        [MJCloud sharedInstance];
    }
    
    [_motionManager setAccelerometerUpdateInterval:1/10.0]; // 1/10.0
    [_motionManager startAccelerometerUpdatesToQueue:_deviceMotionQueue withHandler:
     ^(CMAccelerometerData *accelerometerData, NSError *error)
    {
        if (error)
            [self handleErrorUI:error];
        else {
            if (self.delegate)
                [self.delegate updateAccelerometerData:accelerometerData];
            dispatch_async(self.cloudQueue, ^{
                [self compressAccelerometerData:accelerometerData];
            });
        }
    }];
}

- (void)compressGyroData:(CMGyroData *)gyroData {
    [_gyroRecords addObject:gyroData];
    NSUInteger count = [_gyroRecords count];
    
    if (count >= gyroDataCapacity) {
        NSMutableString *mutable = [NSMutableString stringWithCapacity:networkBufferCapacity];
        
        CMAccelerometerData *data = [_gyroRecords firstObject];
        NSString *dateString = [data dateString];
        [mutable appendString:dateString];
        
        for (int i = 0; i < count; i++) {
            CMAccelerometerData *data = _gyroRecords[i];
            NSString *compressedString = [data compressedString];
            [mutable appendString:compressedString];
        }
        [_gyroRecords removeAllObjects];
        [[MJCloud sharedInstance] sendStringToCloud:mutable];
    }
}

- (void)compressAccelerometerData:(CMAccelerometerData *)accelerometerData {
    [_accelerationRecords addObject:accelerometerData];
    NSUInteger count = [_accelerationRecords count];
    
    if (count >= accelerometerDataCapacity) {
        NSMutableString *mutable = [NSMutableString stringWithCapacity:networkBufferCapacity];
        
        CMAccelerometerData *data = [_accelerationRecords firstObject];
        NSString *dateString = [data dateString];
        [mutable appendString:dateString];
        
        for (int i = 0; i < count; i++) {
            CMAccelerometerData *data = _accelerationRecords[i];
            NSString *compressedString = [data compressedString];
            [mutable appendString:compressedString];
        }
        [_accelerationRecords removeAllObjects];
        [[MJCloud sharedInstance] sendStringToCloud:mutable];
    }
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
