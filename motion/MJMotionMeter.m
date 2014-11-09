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
@property (nonatomic, strong) dispatch_queue_t cloudQueue;
@end

@implementation MJMotionMeter {
    NSUInteger initialCapacity;
}

- (void)dealloc {
    [self setMotionManager:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        initialCapacity = 10 * 24 * 7;
        
        id instance = nil;
        instance = [CMMotionManager new];
        [self setMotionManager:instance];

        dispatch_queue_t queue = dispatch_queue_create("mj.cloudQueue", DISPATCH_QUEUE_SERIAL);
        [self setCloudQueue:queue];
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
                                                  cancelButtonTitle:@"OK"
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
    if (! _gyroRecords) {
        id instance = [[NSMutableArray alloc] initWithCapacity:initialCapacity];
        [self setGyroRecords:instance];
    }

    [_motionManager setGyroUpdateInterval:1/1.0];
    [_motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
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

- (void)stopAccelerometerUpdates {
    if ([_motionManager isAccelerometerActive])
        [_motionManager stopAccelerometerUpdates];
}

- (void)startAccelerometerUpdatesToQueue {
    if (! _accelerationRecords) {
        id instance = [[NSMutableArray alloc] initWithCapacity:initialCapacity];
        [self setAccelerationRecords:instance];
    }
    
    [_motionManager setAccelerometerUpdateInterval:1/10.0]; // 1/10.0
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:
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
    [_accelerationRecords addObject:gyroData];
    NSUInteger count = [_accelerationRecords count];
//    NSLog(@"%s: count:%lu", __func__, (unsigned long)count);
    NSUInteger capacity = 1400;
    
    if (count >= capacity) {
        NSMutableString *mutable = [NSMutableString stringWithCapacity:32 * 1024];
        
        CMAccelerometerData *data = [_accelerationRecords firstObject];
        NSString *dateString = [data dateString];
        [mutable appendString:dateString];
        
        for (int i = 0; i < count; i++) {
            CMAccelerometerData *data = _accelerationRecords[i];
            NSString *compressedString = [data compressedString];
            [mutable appendString:compressedString];
        }
        [_accelerationRecords removeAllObjects];
        [MJCloud sendStringToCloud:mutable];
    }
}

- (void)compressAccelerometerData:(CMAccelerometerData *)accelerometerData {
    [_accelerationRecords addObject:accelerometerData];
    NSUInteger count = [_accelerationRecords count];
    //    NSLog(@"%s: count:%lu", __func__, (unsigned long)count);
    NSUInteger capacity = 1400;
    
    if (count >= capacity) {
        NSMutableString *mutable = [NSMutableString stringWithCapacity:32 * 1024];
        
        CMAccelerometerData *data = [_accelerationRecords firstObject];
        NSString *dateString = [data dateString];
        [mutable appendString:dateString];
        
        for (int i = 0; i < count; i++) {
            CMAccelerometerData *data = _accelerationRecords[i];
            NSString *compressedString = [data compressedString];
            [mutable appendString:compressedString];
        }
        [_accelerationRecords removeAllObjects];
        [MJCloud sendStringToCloud:mutable];
    }
}

- (void)batchUploadCompressedToCloud{
//    [MJCloud sendStringToCloud:_gyroRecords];
//    [MJCloud sendStringToCloud:_accelerationRecords];
}

- (void)collectAndUploadJSONToCloud:(CMAccelerometerData *)accelerometerData {
    [_accelerationRecords addObject:accelerometerData];
    NSUInteger count = [_accelerationRecords count];
    NSUInteger capacity = 550;
    
    if (count >= capacity) {
        NSLog(@"%s: count:%lu", __func__, (unsigned long)count);
        
        NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:capacity];
        for (CMAccelerometerData *data in _accelerationRecords) {
            NSDictionary *dictionary = [data jsonify];
            if (dictionary)
                [mutable addObject:dictionary];
        }
        [_accelerationRecords removeAllObjects];
        [MJCloud uploadCollectionToCloud:mutable];
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
