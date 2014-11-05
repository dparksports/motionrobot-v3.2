#import <UIKit/UIKit.h>

@interface MGLiveMeterView : UIView
@property (nonatomic) float value;

- (void)setupLayerTree;
- (void)setShadowColor:(UIColor*)color;
@end
