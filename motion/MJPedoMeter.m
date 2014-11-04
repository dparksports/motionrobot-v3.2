//
//  MJMotionManager.m
//  motion
//
//  Created by Dan Park on 11/2/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//


#import "MJPedoMeter.h"
#import "MJTimeKeeper.h"
#import "CMPedometerData+MJPedometerData.h"

@interface MJPedoMeter ()
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) NSMutableArray *records;
@end

@implementation MJPedoMeter

- (void)dealloc {
    [self setPedometer:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        id instance = [CMPedometer new];
        [self setPedometer:instance];
    }
    return self;
}

+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    if (! sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [self.class new];
        });
    }
    return sharedInstance;
}

+ (BOOL)checkPedometerAvailableUI{
    NSLog(@"%s", __func__);
    static BOOL available = NO;
    if (! available) {
        available = [CMPedometer isStepCountingAvailable];
        if (! available) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No step counting is available"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        if (! [CMPedometer isDistanceAvailable]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No distance estimation is available"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return available;
}

- (void)checkAuthorizationUI{
    NSLog(@"%s", __func__);
    NSDate *startTime = [MJTimeKeeper startActivityDate];
    [_pedometer queryPedometerDataFromDate:startTime
                                    toDate:startTime
                               withHandler:^(CMPedometerData *pedometerData, NSError *error)
     {
         if (error) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                   
                                                             message:@"Please enable Motion Activity for this application."
                                                            delegate:nil
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void)stopPedometerUpdates{
    [_pedometer stopPedometerUpdates];
}

- (void)startPedometerUpdates{
    NSLog(@"%s", __func__);

    if (! _records) {
        NSUInteger initialCapacity = 10 * 24 * 7;
        id instance = [[NSMutableArray alloc] initWithCapacity:initialCapacity];
        [self setRecords:instance];
    }
    
    NSDate *startTime = [MJTimeKeeper startActivityDate];
    [_pedometer stopPedometerUpdates];
    [_pedometer startPedometerUpdatesFromDate:startTime withHandler:^(CMPedometerData *pedometerData, NSError *error)
    {
        if (error) {
            NSLog(@"%s: Description:%@, RecoverySuggestion:%@, FailureReason:%@", __func__, [error localizedDescription], [error localizedRecoverySuggestion], [error localizedFailureReason]);
        }
        else {
            [_records insertObject:pedometerData atIndex:0];
            NSLog(@"%s: %@", __func__, [pedometerData debugDescription]);
        }
    }];
}

@end
