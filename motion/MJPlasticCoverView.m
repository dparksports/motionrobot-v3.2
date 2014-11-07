//
//  MJPlasticCoverView.m
//  motion
//
//  Created by Dan Park on 11/5/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJPlasticCoverView.h"

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
    [self.layer setBackgroundColor:[UIColor clearColor].CGColor];
    self.layer.contents = (id)[[UIImage imageNamed:@"VUMeterBackground"] CGImage];
    
//    CALayer *foregroundLayer = [CALayer layer];
//    foregroundLayer.anchorPoint = CGPointZero;
//    foregroundLayer.bounds = viewLayerBounds;
//    foregroundLayer.contents = (id)[[UIImage imageNamed:@"VUMeterForeground"] CGImage];
//    foregroundLayer.position = CGPointZero;
//    [self.layer addSublayer:foregroundLayer];
    
    [self  addUnitTickAtRotation:-180/4.0 majorTick:YES];
    [self  addUnitTickAtRotation:(-180/4.0)/3.0*2 majorTick:NO];
    [self  addUnitTickAtRotation:(-180/4.0)/3.0*1 majorTick:NO];
    [self  addUnitTickAtRotation:0.0 majorTick:YES];
    [self  addUnitTickAtRotation:(180/4.0)/3.0*1 majorTick:NO];
    [self  addUnitTickAtRotation:(180/4.0)/3.0*2 majorTick:NO];
    [self  addUnitTickAtRotation:180/4.0 majorTick:YES];
}

@end
