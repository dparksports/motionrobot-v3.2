//
//  MJDigitalPanel.h
//  motion
//
//  Created by Dan Park on 11/10/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "MJOutlinePane.h"

@interface MJDigitalPanel : UIView

- (void)constructPanel;
- (void)updateValue:(NSUInteger)value;
@end
