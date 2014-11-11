//
//  MJCirclePanel.m
//  motion
//
//  Created by Dan Park on 11/10/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJCirclePane.h"

@implementation MJCirclePane

+ (Class)layerClass {
    NSLog(@"%s", __func__);
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"%s", __func__);
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s", __func__);
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)constructSolidCircle {
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1].CGColor;
    
    CGFloat diameter = (self.bounds.size.width >= self.bounds.size.height) ? self.bounds.size.height : self.bounds.size.width;
    CGFloat radius = diameter / 2.0;
    [self roundCorners:radius];
}

- (void)constructPanel {
    [self constructSolidCircle];
}

@end
