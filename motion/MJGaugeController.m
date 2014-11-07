//
//  MJGaugeController.m
//  motion
//
//  Created by Dan Park on 11/4/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJMotionMeter.h"
#import "MGLiveMeterView.h"
#import "MJFuelGuageView.h"
#import "MJPlasticCoverView.h"
#import "CMGyroData+MJGyroData.h"
#import "CMAccelerometerData+MJAccelerometerData.h"
#import "MJGaugeController.h"

@interface MJGaugeController () <MJMotionMeterDelegate>
@property (nonatomic, strong) MJMotionMeter *motionMeter;
@end

@implementation MJGaugeController {    
    __weak IBOutlet MJPlasticCoverView *plasticCover;
    __weak IBOutlet MJFuelGuageView *xAccelerationGauge;
    __weak IBOutlet MJFuelGuageView *yAccelerationGauge;
    __weak IBOutlet MJFuelGuageView *zAccelerationGauge;
    
    __weak IBOutlet UILabel *xGyroLabel;
    __weak IBOutlet UILabel *yGyroLabel;
    __weak IBOutlet UILabel *zGyroLabel;
    
    __weak IBOutlet UILabel *xAccelerationLabel;
    __weak IBOutlet UILabel *yAccelerationLabel;
    __weak IBOutlet UILabel *zAccelerationLabel;
    
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
    [self addGauge];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setMotionMeter:[MJMotionMeter sharedInstance]];
    [_motionMeter setDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - addGauge

- (void)addGauge {
    [xAccelerationGauge addNeedleLayer];
    [yAccelerationGauge addNeedleLayer];
    [zAccelerationGauge addNeedleLayer];
    [plasticCover addUnitTick];

    [xAccelerationGauge setNeedleColor:[UIColor redColor]];
    [yAccelerationGauge setNeedleColor:[UIColor redColor]];
    [zAccelerationGauge setNeedleColor:[UIColor redColor]];

//    [xAccelerationGauge setNeedleColor:[UIColor redColor]];
//    [yAccelerationGauge setNeedleColor:[UIColor greenColor]];
//    [zAccelerationGauge setNeedleColor:[UIColor whiteColor]];
    
//    [xAccelerationGauge setShadowColor:[UIColor orangeColor]];
//    [yAccelerationGauge setShadowColor:[UIColor cyanColor]];
//    [zAccelerationGauge setShadowColor:[UIColor redColor]];
}

#pragma mark - MJMotionMeterDelegate

- (void)updateGyroData:(CMGyroData*)gyroData {
//    NSLog(@"%s: %@", __func__, [gyroData description]);
    
    xGyroLabel.text = [NSString stringWithFormat:@"%1.3f", gyroData.rotationRate.x];
    yGyroLabel.text = [NSString stringWithFormat:@"%1.3f", gyroData.rotationRate.y];
    zGyroLabel.text = [NSString stringWithFormat:@"%1.3f", gyroData.rotationRate.z];
}

- (void)updateAccelerometerData:(CMAccelerometerData*)accelerometerData {
//    NSLog(@"%s: %@", __func__, [accelerometerData xDescription]);
    
    xAccelerationLabel.text = [NSString stringWithFormat:@"%1.3f", accelerometerData.acceleration.x];
    yAccelerationLabel.text = [NSString stringWithFormat:@"%1.3f", accelerometerData.acceleration.y];
    zAccelerationLabel.text = [NSString stringWithFormat:@"%1.3f", accelerometerData.acceleration.z];
    
    [xAccelerationGauge setValue:accelerometerData.acceleration.x];
//    [yAccelerationGauge setValue:accelerometerData.acceleration.y];
//    [zAccelerationGauge setValue:accelerometerData.acceleration.z];
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
