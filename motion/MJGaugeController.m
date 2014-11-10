//
//  MJGaugeController.m
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJMotionMeter.h"
#import "MJGaugePanel.h"
#import "CMGyroData+MJGyroData.h"
#import "CMAccelerometerData+MJAccelerometerData.h"
#import "MJGaugeController.h"

@interface MJGaugeController () <MJMotionMeterDelegate>
@property (nonatomic, strong) MJMotionMeter *motionMeter;
@end

@implementation MJGaugeController {    
    __weak IBOutlet MJGaugePanel *xAccelGaugePanel;
    __weak IBOutlet MJGaugePanel *yAccelGaugePanel;
    __weak IBOutlet MJGaugePanel *zAccelGaugePanel;

    __weak IBOutlet MJGaugePanel *xGyroGaugePanel;
    __weak IBOutlet MJGaugePanel *yGyroGaugePanel;
    __weak IBOutlet MJGaugePanel *zGyroGaugePanel;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    NSLog(@"%s", __func__);
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGauges];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setMotionMeter:[MJMotionMeter sharedInstance]];
    [_motionMeter setDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - addGauge

- (void)addGauges {
    [xAccelGaugePanel constructPanel];
    [yAccelGaugePanel constructPanel];
    [zAccelGaugePanel constructPanel];
    
    [xGyroGaugePanel constructPanel];
    [yGyroGaugePanel constructPanel];
    [zGyroGaugePanel constructPanel];
}

#pragma mark - MJMotionMeterDelegate

- (void)updateGyroData:(CMGyroData*)gyroData {
//    NSLog(@"%s: %@", __func__, [gyroData description]);
    
    [xGyroGaugePanel setValue:gyroData.rotationRate.x];
    [yGyroGaugePanel setValue:gyroData.rotationRate.y];
    [zGyroGaugePanel setValue:gyroData.rotationRate.z];
}

- (void)updateAccelerometerData:(CMAccelerometerData*)accelerometerData {
//    NSLog(@"%s: %@", __func__, [accelerometerData xDescription]);
    
    [xAccelGaugePanel setValue:accelerometerData.acceleration.x];
    [yAccelGaugePanel setValue:accelerometerData.acceleration.y];
    [zAccelGaugePanel setValue:accelerometerData.acceleration.z];
}

#pragma mark - IBAction

- (IBAction)stopGyroUpdates:(id)sender {
    [_motionMeter stopGyroUpdates];
}

- (IBAction)startGyroUpdates:(id)sender {
    if ([_motionMeter checkGyroAvailableUI])
        [_motionMeter startGyroUpdatesToQueue];
}

- (IBAction)stopAccelerometerUpdates:(id)sender {
    [_motionMeter stopAccelerometerUpdates];
}

- (IBAction)startAccelerometerUpdates:(id)sender {
    if ([_motionMeter checkAccelerometerAvailableUI])
        [_motionMeter startAccelerometerUpdatesToQueue];
}

@end
