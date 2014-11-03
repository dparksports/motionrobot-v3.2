//
//  FirstViewController.m
//  motion
//
//  Created by Dan Park on 11/2/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import CoreMotion;

#import "FirstViewController.h"
#import "MJMotionManager.h"

@interface FirstViewController ()
@property (nonatomic, strong) MJMotionManager *motionManager;
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

    if ([MJMotionManager checkActivityAvailableUI]) {
        [self setMotionManager:[MJMotionManager sharedInstance]];
        [_motionManager checkAuthorizationUI];
        [_motionManager startPedometerUpdates];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
