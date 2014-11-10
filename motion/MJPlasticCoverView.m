//
//  MJPlasticCoverView.m
//  motion
//
//  Created by Dan Park on 11/5/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJPlasticCoverView.h"

static inline double radians(double degrees) { return degrees * M_PI / 180; }

@implementation MJPlasticCoverView{
    CALayer *_needleLayer, *_shadowLayer;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

#define SCALE_NEEDLE 1.25

- (void)addUnitTickAtRotation:(CGFloat)degree majorTick:(BOOL)majorTick {
    CGAffineTransform transform = CGAffineTransformMakeScale(SCALE_NEEDLE, SCALE_NEEDLE);
    float radians = M_PI / 180.0 * degree;
    NSLog(@"%s: degree:%1.4f, convert:%1.4f", __func__, degree, radians);
    transform = CGAffineTransformRotate(transform, radians);
    
//    transform = CGAffineTransformRotate(transform, rotation);
    
    CALayer *tickLayer = [CALayer layer];
    tickLayer.affineTransform = transform;
    
    CGFloat width = (majorTick) ? 5 : 3;
    CGFloat height = (majorTick) ? 120 : 115;
    CGFloat heightOffset = (majorTick) ? 40 : 45;
    CGSize needleImageSize = CGSizeMake(width, height);
    CGRect viewLayerBounds = self.layer.bounds;
    
    tickLayer.bounds = CGRectMake(0,0, needleImageSize.width, needleImageSize.height);
    tickLayer.position = CGPointMake(CGRectGetWidth(viewLayerBounds) / 2.0,
                                     needleImageSize.height + heightOffset);
    
    [tickLayer setOpacity:1.0];
    [tickLayer setAnchorPoint:CGPointMake(0.5, 1.0)];
    [tickLayer setBackgroundColor:[UIColor whiteColor].CGColor];
    [self.layer addSublayer:tickLayer];
}

- (void)addUnitTick {
//    [self.layer setBackgroundColor:[UIColor clearColor].CGColor];
//    self.layer.contents = (id)[[UIImage imageNamed:@"VUMeterBackground"] CGImage];
    
//    CALayer *foregroundLayer = [CALayer layer];
//    foregroundLayer.anchorPoint = CGPointZero;
//    foregroundLayer.bounds = viewLayerBounds;
//    foregroundLayer.contents = (id)[[UIImage imageNamed:@"VUMeterForeground"] CGImage];
//    foregroundLayer.position = CGPointZero;
//    [self.layer addSublayer:foregroundLayer];
    
    [self  maskLayer];
    [self  addUnitTickAtRotation:-180/4.0 majorTick:YES];
    [self  addUnitTickAtRotation:(-180/4.0)/3.0*2 majorTick:NO];
    [self  addUnitTickAtRotation:(-180/4.0)/3.0*1 majorTick:NO];
    [self  addUnitTickAtRotation:0.0 majorTick:YES];
    [self  addUnitTickAtRotation:(180/4.0)/3.0*1 majorTick:NO];
    [self  addUnitTickAtRotation:(180/4.0)/3.0*2 majorTick:NO];
    [self  addUnitTickAtRotation:180/4.0 majorTick:YES];
}

- (void)maskLayer {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //    [shapeLayer setBackgroundColor:[UIColor clearColor].CGColor];
    //    [shapeLayer setBorderColor:[UIColor orangeColor].CGColor];
    //    [shapeLayer setBorderWidth:10];
    
//    CGRect viewLayerBounds = self.layer.bounds;
    CGRect boundary = self.layer.bounds;
//    CGRect boundary = self.frame;
    NSLog(@"%s: boundary:%@", __func__, NSStringFromCGRect(boundary));
    NSLog(@"%s: self.frame:%@", __func__, NSStringFromCGRect(self.frame));
    
    float radius = boundary.size.width/2.0 * 0.9;
    CGPoint center =  {boundary.size.width/2.0, boundary.size.height/2.0};
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:center
                    radius:radius
                startAngle:radians(0)
                  endAngle:radians(-180)
                 clockwise:NO];
    
    float innerRadius = radius * 0.6;
    CGPoint halfEdge =  {boundary.size.width/2.0 - innerRadius, boundary.size.height/2.0};
    [path addLineToPoint:halfEdge];
    
    [path addArcWithCenter:center
                    radius:innerRadius
                startAngle:radians(-180)
                  endAngle:radians(0)
                 clockwise:YES];
    //    [path addLineToPoint:center];
    [path closePath];
    //    [path setLineWidth:1.0];
    //    [path setLineJoinStyle:kCGLineJoinRound];
    //    [path closePath];
    //    [path addClip];
//    [[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0] set];
    //    [[UIColor blackColor] set];
//    [path fill];
//    [path addClip];
    
    shapeLayer.position = CGPointMake(0, boundary.size.height/2.0 + 11);
    [shapeLayer setPath:path.CGPath];
//    [self.layer addSublayer:shapeLayer];
    self.layer.mask = shapeLayer;
    

    
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:viewLayerBounds];
//    [shapeLayer setPath:[path CGPath]];
//        shapeLayer.position = CGPointMake(CGRectGetWidth(viewLayerBounds) / 2.0, 80);
//
//    //    [self.layer setBackgroundColor:[UIColor blueColor].CGColor];
//    self.layer.mask = shapeLayer;
//    //    [self.layer setMasksToBounds:YES];
//    
//    
//    [self setNeedsDisplay];
}


//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    NSLog(@"%s", __func__);
//
//    CGRect boundary = self.frame;
//    float radius = boundary.size.width/2.0;
//    float centerSize = radius * .8;
//    
//    UIBezierPath *path;
//    //    path = [[UIBezierPath alloc] init];
//    //    [path addArcWithCenter:center
//    //                    radius:radius
//    //                startAngle:radians(0)
//    //                  endAngle:radians(360)
//    //                 clockwise:YES];
//    //    [path addLineToPoint:center];
//    //    [path closePath];
//    //
//    //    [path setLineWidth:1.];//0.5
//    //    [path setLineJoinStyle:kCGLineJoinRound];
//    //    [[UIColor colorWithRed:1 green:1 blue:0 alpha:1] set];
//    //    [[UIColor colorWithWhite:0.7 alpha:1] set];
//    //    [path fill];
//    
//    path = [[UIBezierPath alloc] init];
//    
//    CGPoint center =  {boundary.size.width/2.0, boundary.size.height/2.0};
//    [path addArcWithCenter:center
//                    radius:radius
//                startAngle:radians(0)
//                  endAngle:radians(-180)
//                 clockwise:NO];
//
//    CGPoint halfEdge =  {boundary.size.width/2.0 - centerSize, boundary.size.height/2.0};
//    [path addLineToPoint:halfEdge];
//    //    [path closePath];
//    //    [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] set];
//    //    [path fill];
//    
//    
//    //    [path setLineWidth:1.];//0.5
//    //    [path setLineJoinStyle:kCGLineJoinRound];
//    //    [[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0] set];
//    //    [path fill];
//    //
//    //    path = [[UIBezierPath alloc] init];
//    
//    center.x = boundary.size.width/2.0;
//    center.y = boundary.size.height/2.0;
//    [path addArcWithCenter:center
//                    radius:centerSize
//                startAngle:radians(-180)
//                  endAngle:radians(0)
//                 clockwise:YES];
//    //    [path addLineToPoint:center];
//    [path closePath];
//    //    [path setLineWidth:1.0];
//    //    [path setLineJoinStyle:kCGLineJoinRound];
//    //    [path closePath];
//    //    [path addClip];
//    [[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0] set];
//    //    [[UIColor blackColor] set];
//    [path fill];
//    [path addClip];
//}


@end
