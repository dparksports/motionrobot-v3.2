//
//  MJLogoPanel.m
//  motion
//
//  Created by Dan Park on 11/10/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJLogoPane.h"

@implementation MJLogoPane

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

- (void)constructPanel {
    [self maskLayer];
    self.alpha = 0.0;
}

- (void)maskLayer {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIImage *image = [UIImage imageNamed:@"share_black_bar_swoosh"];
    shapeLayer.contents = (id)[image CGImage];
    
    CGRect bounds = self.layer.bounds;
    shapeLayer.bounds = CGRectMake(0.0, 0.0,
                                   image.size.width/2.0, image.size.height/2.0);
    shapeLayer.position = CGPointMake(bounds.size.width/2.0, bounds.size.height/2.0);
    [self.layer setMask:shapeLayer];
}
@end
