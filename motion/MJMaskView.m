//
//  MJMaskView.m
//  motion
//
//  Created by Dan Park on 11/5/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//


#import "MJMaskView.h"

static inline double radians(double degrees) { return degrees * M_PI / 180; }

@implementation MJMaskView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.delegate = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.delegate = self;
    }
    return self;
}

-(void)drawLayer:(CALayer*)l inContext:(CGContextRef)context {
    CGRect boundary = self.frame;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGPoint center;
    center.x = boundary.size.width/2.0;
    center.y = boundary.size.height/2.0;
    float radius = boundary.size.width/2.0;
    float centerSize = radius * .8;
    
    UIBezierPath *path;
    path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:center
                    radius:radius
                startAngle:radians(0)
                  endAngle:radians(360)
                 clockwise:YES];
    [path addLineToPoint:center];
    [path closePath];
    
    [path setLineWidth:1.];//0.5
    [path setLineJoinStyle:kCGLineJoinRound];
    [[UIColor colorWithWhite:0.7 alpha:1] set];
    [path fill];
    
    float sAngle = radians(-90);
    float eAngle = radians(180);
    
    path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:center
                    radius:radius
                startAngle:sAngle
                  endAngle:eAngle
                 clockwise:YES];
    [path addLineToPoint:center];
    [path closePath];
    
    [path setLineWidth:1.];//0.5
    [path setLineJoinStyle:kCGLineJoinRound];
    [[UIColor colorWithRed:0.3 green:1.0 blue:0.3 alpha:1] set];
    [path fill];
    
    path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:center
                    radius:centerSize
                startAngle:radians(0)
                  endAngle:radians(360)
                 clockwise:YES];
    [path addLineToPoint:center];
    [path closePath];
    [path setLineWidth:1.];//0.5
    [path setLineJoinStyle:kCGLineJoinRound];
    [[UIColor whiteColor] set];
    [path fill];
    
    CGContextRestoreGState(ctx);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
