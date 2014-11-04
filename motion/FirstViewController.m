//
//  FirstViewController.m
//  motion
//
//  Created by Dan Park on 11/2/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import CoreMotion;
#import "FirstViewController.h"
#import "MJPedoMeter.h"
#import "MJActivityTypeMeter.h"

@interface FirstViewController ()
@property (nonatomic, strong) MJPedoMeter *pedometerManager;
@property (nonatomic, strong) MJActivityTypeMeter *typeManager;
@end

@implementation FirstViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);

    if ([MJPedoMeter checkPedometerAvailableUI]) {
        [self setPedometerManager:[MJPedoMeter sharedInstance]];
        [_pedometerManager checkAuthorizationUI];
        [_pedometerManager startPedometerUpdates];
    }
    
    if ([MJActivityTypeMeter checkActivityTypeAvailableUI]) {
        [self setTypeManager:[MJActivityTypeMeter sharedInstance]];
        [_typeManager checkAuthorizationUI];
        [_typeManager startActivityUpdatesToQueue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%s", __func__);
}

@end
