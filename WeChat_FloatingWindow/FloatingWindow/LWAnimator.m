//
//  LWAnimator.m
//  WeChat_FloatingWindow
//
//  Created by lwmini on 2018/10/25.
//  Copyright © 2018年 lw. All rights reserved.
//

#import "LWAnimator.h"
#import "LWAnimatorView.h"

@implementation LWAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey: UITransitionContextToViewKey];
    [containerView addSubview:toView];
    
    LWAnimatorView *animatorView = [[LWAnimatorView alloc]initWithFrame:toView.bounds];
    [containerView addSubview:animatorView];
    //截屏
    UIGraphicsBeginImageContext(toView.frame.size);
    [toView.layer renderInContext:UIGraphicsGetCurrentContext()];
    animatorView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    toView.hidden = YES;
    
    [animatorView startAnimatingWithView:toView fromRect:_currentRect toRect:toView.frame];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [transitionContext completeTransition:YES]; //移除fromView ,fromeViewController
    });
    
}

@end
