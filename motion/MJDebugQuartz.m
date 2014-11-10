//
//  MJMaskView.m
//  motion
//
//  Created by Dan Park on 11/5/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//


#import "MJDebugQuartz.h"

@implementation MJDebugQuartz

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

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(contextRef);
//    {
//        CGContextSetLineWidth(contextRef, 1.0);
//        CGContextSetStrokeColorWithColor(contextRef, [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor);
//        CGContextStrokeRect(contextRef, rect);
//    }
//    CGContextRestoreGState(contextRef);
}

@end
