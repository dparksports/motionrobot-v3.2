//
//  MJMotionManager.m
//  motion
//
//  Created by Dan Park on 11/2/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import UIKit;
@import CoreMotion;

#import "MJMotionManager.h"

@interface MJMotionManager ()
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) NSMutableArray *movements;
@end

@implementation MJMotionManager

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

+ (NSDate *)startActivityDate{
    NSLog(@"%s", __func__);
    static NSDate *startTime = nil;
    if (! startTime) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            startTime = [NSDate date];
        });
    }
    return startTime;
}

+ (BOOL)checkActivityAvailableUI{
    NSLog(@"%s", __func__);
    static BOOL available = NO;
    if (! available) {
        available = [CMMotionActivityManager isActivityAvailable];
        available &= [CMPedometer isDistanceAvailable];
        available &= [CMPedometer isFloorCountingAvailable];
        
        if (! available) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No activity or step counting is available"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return available;
}

- (void)checkAuthorizationUI{
    NSLog(@"%s", __func__);
    NSDate *startTime = [self.class startActivityDate];
    [_pedometer queryPedometerDataFromDate:startTime
                                    toDate:startTime
                               withHandler:^(CMPedometerData *pedometerData, NSError *error)
     {
         BOOL notAuthorized = error || error.code == CMErrorMotionActivityNotAuthorized;
         if (notAuthorized) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                   
                                                             message:@"Please enable Motion Activity for this application."
                                                            delegate:nil
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void)dealloc {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        id instance = [CMPedometer new];
        [self setPedometer:instance];
    }
    return self;
}

- (void)stopPedometerUpdates{
    [_pedometer stopPedometerUpdates];
}

- (void)startPedometerUpdates{
    NSLog(@"%s", __func__);

    if (! _movements) {
        NSUInteger initialCapacity = 10 * 24 * 7;
        id instance = [[NSMutableArray alloc] initWithCapacity:initialCapacity];
        [self setMovements:instance];
    }
    
    NSDate *startTime = [self.class startActivityDate];
    [_pedometer stopPedometerUpdates];
    [_pedometer startPedometerUpdatesFromDate:startTime withHandler:^(CMPedometerData *pedometerData, NSError *error)
    {
        if (error) {
            NSLog(@"%s: Description:%@, RecoverySuggestion:%@, FailureReason:%@", __func__, [error localizedDescription], [error localizedRecoverySuggestion], [error localizedFailureReason]);
        }
        else {
            [_movements addObject:pedometerData];
            NSLog(@"%s: Description:%@, debugDescription:%@", __func__, [pedometerData description], [pedometerData debugDescription]);
        }
    }];
}

@end
