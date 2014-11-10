//
//  MJMaskView.m
//  motion
//
//  Created by Dan Park on 11/5/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//


#import "MJMaskView.h"

static inline double radians(double degrees) { return degrees * M_PI / 180; }

@implementation MJMaskView {
    CAShapeLayer *shapeLayer;
}

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

- (void)maskLayer {
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.delegate = self;
    [self.layer addSublayer:shapeLayer];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    NSLog(@"%s", __func__);
    CGRect boundary = self.frame;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    float radius = boundary.size.width/2.0;
    
    UIBezierPath *path;
//    path = [[UIBezierPath alloc] init];
//    [path addArcWithCenter:center
//                    radius:radius
//                startAngle:radians(0)
//                  endAngle:radians(360)
//                 clockwise:YES];
//    [path addLineToPoint:center];
//    [path closePath];
//    
//    [path setLineWidth:1.];//0.5
//    [path setLineJoinStyle:kCGLineJoinRound];
//    [[UIColor colorWithRed:1 green:1 blue:0 alpha:1] set];
//    [[UIColor colorWithWhite:0.7 alpha:1] set];
//    [path fill];
    
    path = [[UIBezierPath alloc] init];
    CGPoint center =  {boundary.size.width/2.0, boundary.size.height/2.0};
    [path addArcWithCenter:center
                    radius:radius
                startAngle:radians(0)
                  endAngle:radians(-180)
                 clockwise:NO];
    
    float centerSize = radius / 4.0 ;
    CGPoint halfEdge =  {boundary.size.width/2.0 - centerSize, boundary.size.height/2.0};
    [path addLineToPoint:halfEdge];
//    [path closePath];
//    [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] set];
//    [path fill];
    
    
//    [path setLineWidth:1.];//0.5
//    [path setLineJoinStyle:kCGLineJoinRound];
//    [[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0] set];
//    [path fill];
//    
//    path = [[UIBezierPath alloc] init];
    
    [path addArcWithCenter:center
                    radius:centerSize
                startAngle:radians(-180)
                  endAngle:radians(0)
                 clockwise:YES];
//    [path addLineToPoint:center];
    [path closePath];
//    [path setLineWidth:1.0];
//    [path setLineJoinStyle:kCGLineJoinRound];
//    [path closePath];
    

    
//    [path addClip];
    [[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0] set];
//    [[UIColor blackColor] set];
    [path fill];

    
    [path moveToPoint:center];
    [path addLineToPoint:center];
    
    CGContextRestoreGState(ctx);
}

//- (void)drawRect:(CGRect)rect {
//    NSLog(@"%s", __func__);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(ctx);
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
//    [[UIColor colorWithWhite:1 alpha:1] set];
//    [path fill];
//    
//    CGContextRestoreGState(ctx);
//}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(contextRef);
//    {
//        CGContextSetLineWidth(contextRef, 1.0);
//        CGContextSetStrokeColorWithColor(contextRef, [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor);
//        CGContextStrokeRect(contextRef, rect);
//    }
//    CGContextRestoreGState(contextRef);
//}

@end
