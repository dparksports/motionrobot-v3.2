/*
     File: MYVolumeUnitMeterView.m
 Abstract: Volume unit meter view
  Version: 1.0
*/

#import "MGLiveMeterView.h"

#import <QuartzCore/QuartzCore.h>

// This is an arbitrary calibration to define 0 db in the VU meter.
#define MYVolumeUnitMeterView_CALIBRATION 12.0f
#define DEGREE_TO_RADIAN M_PI / 180.0f

static CGFloat convertValueToNeedleAngle(CGFloat value);
static CGFloat convertXValueToNeedleAngle(CGFloat value);

@interface MGLiveMeterView () {
    BOOL constructed;
}
@property (readonly, strong, nonatomic) CALayer *needleLayer;
@property (strong, nonatomic) CALayer *shadowLayer;
@end

@implementation MGLiveMeterView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self)
	{
//		[self setupLayerTree];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self)
	{
//		[self setupLayerTree];
	}
	
	return self;
}

#define SCALE_NEEDLE 1.25

- (void)setupLayerTree
{
	CGRect viewLayerBounds = self.layer.bounds;
	
//#define SHOW_METER_BACKGROUND
#ifdef SHOW_METER_BACKGROUND
	self.layer.contents = (id)[[UIImage imageNamed:@"VUMeterBackground"] CGImage];
#endif
//    self.layer.opacity = .1;
    [self.layer setBackgroundColor:[UIColor clearColor].CGColor];
	
	// Add shadow layer for needle.
	_shadowLayer = [CALayer layer];
//	_shadowLayer.shadowColor = [[UIColor redColor] CGColor];
	_shadowLayer.shadowRadius = 0.0f;
	_shadowLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
	_shadowLayer.shadowOpacity = 1.0f;
	[self.layer addSublayer:_shadowLayer];
	
	// Add needle layer.
	UIImage *needleImage = [UIImage imageNamed:@"VUMeterNeedle"];
	CGSize needleImageSize = [needleImage size];
	_needleLayer = [CALayer layer];
	[_needleLayer setContents:(id)[needleImage CGImage]];
	[_needleLayer setOpacity:1.0];
    
	CGAffineTransform transform = CGAffineTransformMakeScale(SCALE_NEEDLE, SCALE_NEEDLE);
	transform = CGAffineTransformRotate(transform, convertValueToNeedleAngle(-INFINITY));
	_needleLayer.affineTransform = transform;
    _needleLayer.drawsAsynchronously = YES; 
	_needleLayer.anchorPoint = CGPointMake(0.5f, 1.0f);
	_needleLayer.bounds = CGRectMake(0.0f, 0.0f,
                                     needleImageSize.width, needleImageSize.height);
	_needleLayer.position = CGPointMake(CGRectGetWidth(viewLayerBounds) / 2.0,
                                        needleImageSize.height);
    [_shadowLayer addSublayer:_needleLayer];

#define SHOW_PLASTIC_COVER
#ifdef SHOW_PLASTIC_COVER
	// Add foreground layer.
	CALayer *foregroundLayer = [CALayer layer];
//	[foregroundLayer setOpacity:0.1];//0.3
	foregroundLayer.anchorPoint = CGPointZero;
	foregroundLayer.bounds = viewLayerBounds;
	foregroundLayer.contents = (id)[[UIImage imageNamed:@"VUMeterForeground"] CGImage];
	foregroundLayer.position = CGPointZero;
	[self.layer addSublayer:foregroundLayer];
//	[self.layer insertSublayer:foregroundLayer below:_needleLayer];
//	[self.layer insertSublayer:foregroundLayer above:_needleLayer];
#endif
}

#pragma mark -

- (void)setShadowColor:(UIColor*)color {
    _shadowLayer.shadowColor = [color CGColor];
}

- (void)setValue:(float)value {
	if (_value != value) {
		_value = value;
		
        float convert = convertXValueToNeedleAngle(value);
//        NSLog(@"%s: %1.4f, convert:%1.4f", __func__,
//              value, convert);
        CGAffineTransform transform = CGAffineTransformMakeScale(SCALE_NEEDLE, SCALE_NEEDLE);
        transform = CGAffineTransformRotate(transform, convert);
		_needleLayer.affineTransform = transform;
	}
}

@end

// Note: This calculation is just an approximation to map the artwork.
static CGFloat convertXValueToNeedleAngle(CGFloat value) {
    float degree = value * 60.0 * (4/5.0);
    return (DEGREE_TO_RADIAN * degree);
}

// Note: This calculation is just an approximation to map the artwork.
static CGFloat convertValueToNeedleAngle(CGFloat value) {
	float degree = (value * 5.0f + 20.0f);
	
	// The mapping from dB amplitude to angle is not linear on our VU meter.
	if (value < -7.0f && value >= -10.0f)
		degree = (-15.0f + (10.0f / 3.0f) * (value + 7.0f));
	else if (value < -10.0f)
		degree = (-25.0f + (13.0f / 10.0f) * (value + 10.0f));
	
	// Limit to visible angle.
	degree = MAX(-38.0f, MIN(degree, 43.0f));
	
	return (DEGREE_TO_RADIAN * degree);
}
