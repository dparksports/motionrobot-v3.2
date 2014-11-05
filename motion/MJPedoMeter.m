//
//  MJMotionManager.m
//  motion
//
//  Created by Dan Park on 11/2/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

static void *MJPedometerUpdateContextKVO = &MJPedometerUpdateContextKVO;

#import "MJPedoMeter.h"
#import "MJTimeKeeper.h"
#import "CMPedometerData+MJPedometerData.h"

@interface MJPedoMeter ()
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) BOOL updatedRecords;
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

#pragma mark - KVO

+ (NSSet *)keyPathsForValuesAffectingRecords {
    NSLog(@"%s", __func__);
    return [NSSet setWithObjects:@"pedometer", @"updatedRecords", nil];
}

- (void)unregisterObserverKVO:(NSObject *)anObserver  {
    NSLog(@"%s", __func__);
    
    [self removeObserver:anObserver forKeyPath:@"records" context:MJPedometerUpdateContextKVO];
}

- (void)registerObserverKVO:(NSObject *)anObserver {
    NSLog(@"%s", __func__);
    
    [self addObserver:anObserver forKeyPath:@"records" options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld ) context:MJPedometerUpdateContextKVO];
}

#pragma mark - checkActivityTypeAvailableUI

+ (BOOL)checkPedometerAvailableUI{
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
    NSDate *startTime = [MJTimeKeeper startActivityDate];
    [_pedometer queryPedometerDataFromDate:startTime
                                    toDate:startTime
                               withHandler:
     ^(CMPedometerData *pedometerData, NSError *error)
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

#pragma mark - startPedometerUpdates

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
    [_pedometer startPedometerUpdatesFromDate:startTime withHandler:
     ^(CMPedometerData *pedometerData, NSError *error)
    {
        if (error)
            [self handleErrorUI:error];
        else {
            [_records insertObject:pedometerData atIndex:0];
            [self setUpdatedRecords:! _updatedRecords];
            NSLog(@"%s: %@", __func__, [pedometerData debugDescription]);
        }
    }];
}

#pragma mark - NSError

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
