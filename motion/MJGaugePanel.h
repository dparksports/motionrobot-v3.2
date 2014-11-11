//
//  MJGaugePanel.h
//  motion
//
//  Created by Dan Park on 11/9/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import UIKit;
#import "MJRoundPane.h"

@interface MJGaugePanel : MJRoundPane
@property (nonatomic, readwrite) float value;

- (void)constructPanel;
@end
