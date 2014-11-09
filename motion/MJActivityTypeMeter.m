//
//  MJActivityTypeManager.m
//  motion
//
//  Created by Dan Park on 11/3/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

static void *MJActivityTypeUpdateContextKVO = &MJActivityTypeUpdateContextKVO;

#import "MJActivityTypeMeter.h"
#import "MJTimeKeeper.h"

@interface MJActivityTypeMeter ()
@property (nonatomic, strong) CMMotionActivityManager *activityTypeManager;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) BOOL updatedRecords;
@end

@implementation MJActivityTypeMeter

- (void)dealloc {
    [self setActivityTypeManager:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        id instance = [CMMotionActivityManager new];
        [self setActivityTypeManager:instance];
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
    return [NSSet setWithObjects:@"activityTypeManager", @"updatedRecords", nil];
}

- (void)unregisterObserverKVO:(NSObject *)anObserver  {
    NSLog(@"%s", __func__);
    
    [self removeObserver:anObserver forKeyPath:@"records" context:MJActivityTypeUpdateContextKVO];
}

- (void)registerObserverKVO:(NSObject *)anObserver {
    NSLog(@"%s", __func__);
    
    [self addObserver:anObserver forKeyPath:@"records" options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld ) context:MJActivityTypeUpdateContextKVO];
}

#pragma mark - checkActivityTypeAvailableUI

+ (BOOL)checkActivityTypeAvailableUI{
    static BOOL available = NO;
    if (! available) {
        available = [CMMotionActivityManager isActivityAvailable];
        if (! available) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No activity counting is available."
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
    
    [_activityTypeManager queryActivityStartingFromDate:startTime
                                               toDate:startTime
                                              toQueue:[NSOperationQueue mainQueue]
                                          withHandler:
     ^(NSArray *activities, NSError *error)
    {
        if (error || error.code == CMErrorMotionActivityNotAuthorized) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                  
                                                            message:@"Please enable Motion Activity for this application."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark - startActivityUpdatesToQueue

- (void)stopActivityUpdates{
    [_activityTypeManager stopActivityUpdates];
}

- (void)startActivityUpdatesToQueue{
    
    [_activityTypeManager stopActivityUpdates];
    [_activityTypeManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                          withHandler:^(CMMotionActivity *activity)
    {
        if (activity) {
            [_records insertObject:activity atIndex:0];
            [self setUpdatedRecords:! _updatedRecords];
//            NSLog(@"%s: %@", __func__, [activity debugDescription]);
        }
    }];
}

@end
