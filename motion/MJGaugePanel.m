//
//  MJGaugePanel.m
//  motion
//
//  Created by Dan Park on 11/9/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJFuelGuageView.h"
#import "MJPlasticCoverView.h"
#import "MJGaugePanel.h"
#import "MJVelocityGuageView.h"

@implementation MJGaugePanel {
    __weak IBOutlet MJPlasticCoverView *plasticCover;
    __weak IBOutlet MJFuelGuageView *guageView;
    __weak IBOutlet MJVelocityGuageView *velocityView;
    
    __weak IBOutlet UILabel *positiveMajorUnitLabel;
    __weak IBOutlet UILabel *negativeMajorUnitLabel;
    __weak IBOutlet UILabel *zeroMajorUnitLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
        self.clipsToBounds = YES;
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
        self.clipsToBounds = YES;
    return self;
}

- (void)constructPanel {
    [plasticCover addUnitTicks];
    if (guageView)
        [guageView addNeedleLayer];
    if (velocityView)
        [velocityView addNeedleLayer];
}

- (void)setValue:(float)value {
    if (guageView)
        [guageView setValue:value];
    if (velocityView)
        [velocityView setValue:value];
}

@end
