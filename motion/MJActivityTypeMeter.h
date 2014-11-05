//
//  MJActivityTypeManager.h
//  motion
//
//  Created by Dan Park on 11/3/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreMotion;

@interface MJActivityTypeMeter : NSObject
@property (nonatomic, readonly) NSMutableArray *records;

+ (instancetype)sharedInstance;

+ (BOOL)checkActivityTypeAvailableUI;
- (void)checkAuthorizationUI;

- (void)unregisterObserverKVO:(NSObject *)anObserver;
- (void)registerObserverKVO:(NSObject *)anObserver;

- (void)stopActivityUpdates;
- (void)startActivityUpdatesToQueue;
@end
