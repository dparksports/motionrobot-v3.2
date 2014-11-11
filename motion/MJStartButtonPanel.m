//
//  MJStartButtonPanel.m
//  motion
//
//  Created by Dan Park on 11/11/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJCirclePanel.h"
#import "MJLogoPanel.h"
#import "MJStartButtonPanel.h"

@implementation MJStartButtonPanel {
    __weak IBOutlet MJCirclePanel *circlePanel;
    __weak IBOutlet MJLogoPanel *logoPanel;
    __weak IBOutlet UILabel *startMomentLabel;
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
    [circlePanel constructPanel];
    [logoPanel constructPanel];
}

- (void)toggleAccelerometerUpdates:(BOOL)isOn {
    if (isOn) {
        startMomentLabel.text = @"STOP MOMENT";
    } else {
        startMomentLabel.text = @"BEGIN MOMENT";
    }
    
    [UIView animateWithDuration:1/2.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:
     ^(void)
     {
         logoPanel.alpha = (logoPanel.alpha > 0) ? 0.0 : 1.0;
     }
                     completion:
     ^(BOOL finished)
     {
     }];
}

@end
