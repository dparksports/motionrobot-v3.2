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

@implementation MJGaugePanel {
    __weak IBOutlet MJPlasticCoverView *plasticCover;
    __weak IBOutlet MJFuelGuageView *guageView;
    __weak IBOutlet UILabel *xLabel;
    __weak IBOutlet UILabel *yLabel;
    __weak IBOutlet UILabel *zLabel;
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
    [guageView addNeedleLayer];
}

- (void)setValue:(float)value {
    [guageView setValue:value];
}

@end
