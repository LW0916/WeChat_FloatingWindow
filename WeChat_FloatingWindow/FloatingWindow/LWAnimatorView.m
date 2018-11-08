//
//  LWAnimatorView.m
//  WeChat_FloatingWindow
//
//  Created by lwmini on 2018/10/26.
//  Copyright © 2018年 lw. All rights reserved.
//

#import "LWAnimatorView.h"

@interface LWAnimatorView ()<CAAnimationDelegate>{
    CAShapeLayer *_shapeLayer;
    UIView *_toView;
}

@end
@implementation LWAnimatorView
- (void)startAnimatingWithView:(UIView *)theView fromRect:(CGRect)fromRect toRect:(CGRect)toRect{
    _toView = theView;
    //mask 和floatingBtn大小一致的btn
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:fromRect cornerRadius:30.f].CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = (__bridge id _Nullable)([UIBezierPath bezierPathWithRoundedRect:toRect cornerRadius:30.f].CGPath);
    animation.duration = 0.5f;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [_shapeLayer addAnimation:animation forKey:nil];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _toView.hidden = NO;
    [_shapeLayer removeAllAnimations];
    [self removeFromSuperview];
}

@end
