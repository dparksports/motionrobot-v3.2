//
//  MJRoundPanel.m
//  motion
//
//  Created by Dan Park on 11/9/14.
//  Copyright (c) 2014 Dan Park. All rights reserved.
//

#import "MJRoundPane.h"

@implementation MJRoundPane

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
        [self roundCorners:8.0];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
        [self roundCorners:8.0];
    return self;
}

- (void)roundCorners:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

@end
