//
//  MJVelocityGuageView.m
//  motion
//
//  Created by Dan Park on 11/15/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJVelocityGuageView.h"

#define DEGREE_TO_RADIAN M_PI / 180.0f
#define ANGLE_AT_REST -45

static CGFloat convertVelocityToDisplayAngle(CGFloat value) {
    float amphlified = value * 2;
    float degree = amphlified * 60;
    float degreeAtOrigin = degree + ANGLE_AT_REST;
    float radians = M_PI / 180.0 * degreeAtOrigin;
    return radians;
}

@implementation MJVelocityGuageView {
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

- (void)addNeedleLayer {
    CGRect viewLayerBounds = self.layer.bounds;
    [self.layer setBackgroundColor:[UIColor clearColor].CGColor];
    
    // Add shadow layer for needle.
    _shadowLayer = [CALayer layer];
    _shadowLayer.shadowColor = [[UIColor blackColor] CGColor];
    _shadowLayer.shadowRadius = 1.0;
    _shadowLayer.shadowOffset = CGSizeMake(2.0, 2.0);
    _shadowLayer.shadowOpacity = 0.9;
    [self.layer addSublayer:_shadowLayer];
    
    // Add needle layer.
    CGSize needleImageSize = CGSizeMake(4, 110);
    _needleLayer = [CALayer layer];
    [_needleLayer setBackgroundColor:[UIColor redColor].CGColor];
    [_needleLayer setOpacity:1.0];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.25, 1.25);
    transform = CGAffineTransformRotate(transform, (DEGREE_TO_RADIAN * ANGLE_AT_REST));
    _needleLayer.affineTransform = transform;
    _needleLayer.drawsAsynchronously = YES;
    _needleLayer.anchorPoint = CGPointMake(0.5, 1.0);
    _needleLayer.bounds = CGRectMake(0.0, 0.0,
                                     needleImageSize.width, needleImageSize.height);
    _needleLayer.position = CGPointMake(CGRectGetWidth(viewLayerBounds) / 2.0,
                                        needleImageSize.height + 50);
    [_shadowLayer addSublayer:_needleLayer];
}

- (void)setShadowColor:(UIColor*)color {
    _shadowLayer.shadowColor = [color CGColor];
}

- (void)setNeedleColor:(UIColor*)color {
    [_needleLayer setBackgroundColor:[color CGColor]];
}

- (void)setValue:(float)value {
    if (_value != value) {
        _value = value;
        
        dispatch_async(dispatch_get_main_queue(), ^()
        {
            float convert = convertVelocityToDisplayAngle(value);
            //            NSLog(@"%s: %1.4f, convert:%1.4f", __func__, value, convert);
            
            CGAffineTransform transform = CGAffineTransformMakeScale(1.25, 1.25);
            transform = CGAffineTransformRotate(transform, convert);
            _needleLayer.affineTransform = transform;
        });
    }
}

@end
