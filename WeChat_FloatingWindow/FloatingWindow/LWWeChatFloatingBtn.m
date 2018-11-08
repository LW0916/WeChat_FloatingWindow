//
//  LWWeChatFloatingBtn.m
//  WeChat_FloatingWindow
//
//  Created by lwmini on 2018/10/24.
//  Copyright © 2018年 lw. All rights reserved.
//

#import "LWWeChatFloatingBtn.h"
#import "LWSemiCircleView.h"
#import "LWNextViewController.h"
#import "LWAnimator.h"

#define   UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define   UISCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define   kStateBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define   kFixedSpace 160.f
#define   kFloatingBtn_W_H 60.f
@interface LWWeChatFloatingBtn ()<UINavigationControllerDelegate>{
    CGPoint lastPoint;
    CGPoint pointInSelf;
}

@end

@implementation LWWeChatFloatingBtn
static LWWeChatFloatingBtn *floatingBtn;
static LWSemiCircleView *semiCircleView;

+ (void)show{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatingBtn = [[LWWeChatFloatingBtn alloc]initWithFrame:CGRectMake(10, 200, kFloatingBtn_W_H, kFloatingBtn_W_H)];
        semiCircleView = [[LWSemiCircleView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH, UISCREEN_HEIGHT, kFixedSpace, kFixedSpace)];
    });
    
    if (!semiCircleView.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:semiCircleView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:semiCircleView];
    }
    
    if (!floatingBtn.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:floatingBtn];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:floatingBtn];
    }
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.layer.contents = (__bridge id)[UIImage imageNamed:@"floatBtn"].CGImage;
    return self;
}
#pragma mark - UITouch method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.superview];
    pointInSelf = [touch locationInView:self];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    //四分之一圆动画显示出来
    if (CGRectEqualToRect(semiCircleView.frame, CGRectMake(UISCREEN_WIDTH, UISCREEN_HEIGHT, kFixedSpace, kFixedSpace))) {
        [UIView animateWithDuration:0.2f animations:^{
            semiCircleView.frame =  CGRectMake(UISCREEN_WIDTH - kFixedSpace, UISCREEN_HEIGHT- kFixedSpace, kFixedSpace, kFixedSpace);
        }];
    }
    //计算出来floatingBtn的center坐标
    CGFloat centerX = currentPoint.x + (self.frame.size.width/2 - pointInSelf.x);
    CGFloat centerY = currentPoint.y + (self.frame.size.height/2 - pointInSelf.y);
    //限制center坐标的范围值，不超过屏幕
//      30<= x <= [UIScreen mainScreen].bounds.size.width - 30
//      30<= y <= [UIScreen mainScreen].bounds.size.height - 30
    CGFloat x = MAX(kFloatingBtn_W_H/2, MIN(UISCREEN_WIDTH - kFloatingBtn_W_H/2, centerX));
    CGFloat y = MAX(kFloatingBtn_W_H/2, MIN(UISCREEN_HEIGHT - kFloatingBtn_W_H/2, centerY));
    
    self.center = CGPointMake(x, y);

    
    //判断是否放大 semiCircleView
    //两个圆心的距离 <= 两个半径只差；说明了floatingBtn可以移除了
    CGAffineTransform newT=CGAffineTransformMakeScale(1.1, 1.1);
//    semiCircleView.layer.anchorPoint = CGPointMake(1, 1);
    CGFloat distance = sqrt(pow(UISCREEN_WIDTH-self.center.x, 2)+pow(UISCREEN_HEIGHT - self.center.y, 2));
    if (distance <= kFixedSpace - kFloatingBtn_W_H/2) {
        if (@available(iOS 10.0, *)) {//震动效果
            UIImpactFeedbackGenerator * imp = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
            [imp impactOccurred];
        }
        semiCircleView.transform = newT;
    }else{
        semiCircleView.transform = CGAffineTransformIdentity;
    }
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    semiCircleView.transform=CGAffineTransformIdentity;
    if (CGRectEqualToRect(semiCircleView.frame, CGRectMake(UISCREEN_WIDTH - kFixedSpace, UISCREEN_HEIGHT- kFixedSpace, kFixedSpace, kFixedSpace))) {
        [UIView animateWithDuration:0.2f animations:^{
         semiCircleView.frame =  CGRectMake(UISCREEN_WIDTH, UISCREEN_HEIGHT, kFixedSpace, kFixedSpace);
        }];
    }
    if (CGPointEqualToPoint(lastPoint, currentPoint)) {
        UINavigationController *nav = (UINavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
        nav.delegate = self;
        LWNextViewController *nextVC = [[LWNextViewController alloc]init];
        [nav pushViewController:nextVC animated:YES];
        return;
    }
    //判断是否移除floatingBtn
    //两个圆心的距离 <= 两个半径只差；说明了floatingBtn可以移除了
    CGFloat distance = sqrt(pow(UISCREEN_WIDTH-self.center.x, 2)+pow(UISCREEN_HEIGHT - self.center.y, 2));
    if (distance <= kFixedSpace - kFloatingBtn_W_H/2) {
        [UIView animateWithDuration:0.2f animations:^{
            [self removeFromSuperview];
            [self setCenter:CGPointMake(self->lastPoint.x + (self.frame.size.width/2 - self->pointInSelf.x), self->lastPoint.y + (self.frame.size.height/2 - self->pointInSelf.y))];
        }];
    }
   
    //离左侧两侧的距离
    CGFloat gap =10;
    CGFloat leftMargin = self.center.x;
    CGFloat rightMargin = UISCREEN_WIDTH - leftMargin;
    CGFloat centerX,centerY = self.center.y > (kStateBarHeight + kFloatingBtn_W_H/2)? self.center.y:(kStateBarHeight + kFloatingBtn_W_H/2);
    if (leftMargin < rightMargin) {
        centerX = kFloatingBtn_W_H/2 +gap;
    }else{
        centerX =UISCREEN_WIDTH - (kFloatingBtn_W_H/2+gap);
    }

    [UIView animateWithDuration:0.2f animations:^{
        self.center = CGPointMake(centerX, centerY);
    }];
}
#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        LWAnimator *animator = [[LWAnimator alloc]init];
        animator.currentRect = self.frame;
        return animator;
    }
    return nil;
}

@end
