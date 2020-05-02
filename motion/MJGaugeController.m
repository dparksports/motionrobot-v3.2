//
//  MJGaugeController.m
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

// meters
#import "MJPedoMeter.h"
#import "MJMotionMeter.h"
// custom views
#import "MJDigitalPanel.h"
#import "MJGaugePanel.h"
#import "MJRoundPane.h"
#import "MJStartButtonPanel.h"

// descriptions
#import "CMDeviceMotion+MJDeviceMotion.h"
#import "CMGyroData+MJGyroData.h"
#import "CMAccelerometerData+MJAccelerometerData.h"
#import "CMPedometerData+MJPedometerData.h"
#import "MJGaugeController.h"

@interface MJGaugeController () <MJMotionMeterDelegate>
@property (nonatomic, strong) MJMotionMeter *motionMeter;
@property (nonatomic, strong) MJPedoMeter *pedometerManager;
@end

@implementation MJGaugeController {
    double deviceMotionSum;

    __weak IBOutlet MJGaugePanel *velocityGaugePanel;
    __weak IBOutlet MJGaugePanel *zAccelGaugePanel;
    
    __weak IBOutlet MJDigitalPanel *distanceDigitalPanel;
    __weak IBOutlet MJDigitalPanel *calculatedDigitalPanel;
    __weak IBOutlet MJStartButtonPanel *startButtonPanel;
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
    
    if ([MJPedoMeter checkPedometerAvailableUI]) {
        [self setPedometerManager:[MJPedoMeter sharedInstance]];
        [_pedometerManager checkAuthorizationUI];
        [_pedometerManager startPedometerUpdates];
        [self registerObserverKVO];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unregisterObserverKVO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskPortrait;
    return mask;
}

- (BOOL)shouldAutorotate{
    // support the portrait view only.
    return NO;
}

#pragma mark - KVO - MJPedoMeter

- (void)unregisterObserverKVO {
    NSLog(@"%s", __func__);
    
    [_pedometerManager unregisterObserverKVO:self];
}

- (void)registerObserverKVO {
    NSLog(@"%s", __func__);
    
    [_pedometerManager registerObserverKVO:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //    NSLog(@"%s: keyPath:%@, change:%@", __func__, keyPath, change);
    
    if ([keyPath isEqualToString:@"records"] ) {
        CMPedometerData *pedometerData = [_pedometerManager.records lastObject];
        
        NSUInteger normalizedDistance = [pedometerData normalizedFractalDistance];
        [distanceDigitalPanel updateValue:normalizedDistance];
        
//        float value = deviceMotionSum * 10;
//        float normalizeFraction = ceilf(value);
//        NSUInteger distance = (NSUInteger) normalizeFraction;
//        [calculatedDigitalPanel updateValue:distance];
        
        NSLog(@"%s: normalizedDistance:%lu", __func__, (unsigned long)normalizedDistance);
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - addGauge

- (void)addGauges {
    [velocityGaugePanel constructPanel];
    [zAccelGaugePanel constructPanel];
    [distanceDigitalPanel constructPanel];
    [calculatedDigitalPanel constructPanel];
    [startButtonPanel constructPanel];
}

#pragma mark - MJMotionMeterDelegate

- (void)updateMotionData:(CMDeviceMotion*)motionData sum:(double)motionSum{
//    NSLog(@"%s: %@", __func__, [motionData description]);
    
    deviceMotionSum = motionSum;
    double vectorVelocity = [motionData velocity];
    [velocityGaugePanel setValue:vectorVelocity];
    [zAccelGaugePanel setValue:motionData.userAcceleration.z];
}

- (void)updateGyroData:(CMGyroData*)gyroData {
//    NSLog(@"%s: %@", __func__, [gyroData description]);
    
    float value = deviceMotionSum * 10;
    float normalizeFraction = ceilf(value);
    NSUInteger distance = (NSUInteger) normalizeFraction;
    [calculatedDigitalPanel updateValue:distance];
}

- (void)updateAccelerometerData:(CMAccelerometerData*)accelerometerData {
//    NSLog(@"%s: %@", __func__, [accelerometerData xDescription]);
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

- (IBAction)toggleAccelerometerUpdates:(id)sender {
    if ([_motionMeter isAccelerometerActive]) {
        [_motionMeter stopAccelerometerUpdates];
        [startButtonPanel toggleAccelerometerUpdates:NO];
    } else {
        if ([_motionMeter checkAccelerometerAvailableUI]) {
            [_motionMeter startAccelerometerUpdatesToQueue];
            [startButtonPanel toggleAccelerometerUpdates:YES];
        }
    }
}

- (IBAction)toggleDeviceMotionUpdates:(id)sender {
    if ([_motionMeter isDeviceMotionActive] &&
        [_motionMeter isGyroActive]) {
        [_motionMeter stopGyroUpdates];
        [_motionMeter stopDeviceMotionUpdates];
        [startButtonPanel toggleAccelerometerUpdates:NO];
    } else {
        if ([_motionMeter checkDeviceMotionAvailableUI] &&
            [_motionMeter checkGyroAvailableUI]) {
            [_motionMeter startGyroUpdatesToQueue];
            [_motionMeter startDeviceMotionUpdatesToQueue];
            [startButtonPanel toggleAccelerometerUpdates:YES];
        }
    }
}

@end
