//
//  MJFuelGuageView.h
//  motion
//
//  Created by Dan Park on 11/5/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJFuelGuageView : UIView
@property (nonatomic, readwrite) float value;

- (void)addNeedleLayer;
- (void)setShadowColor:(UIColor*)color;
- (void)setNeedleColor:(UIColor*)color;
@end
