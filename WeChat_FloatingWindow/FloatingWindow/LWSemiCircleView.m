//
//  LWSemiCircleView.m
//  WeChat_FloatingWindow
//
//  Created by lwmini on 2018/10/24.
//  Copyright © 2018年 lw. All rights reserved.
//

#import "LWSemiCircleView.h"
#define kLeft_Gap 10
@implementation LWSemiCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(ctx, 0, self.bounds.size.height);
    CGContextAddArc(ctx, self.bounds.size.width, self.bounds.size.height, self.bounds.size.height, M_PI, M_PI_2 + M_PI, 0); //添加圆的绘制路径
    CGContextSetLineWidth(ctx, 1);
    //设置状态的颜色  set 同时设置空心 实心
    [[UIColor colorWithRed:0.87 green:0.33 blue:0.35 alpha:1.00] set];
    CGContextClosePath(ctx);
    //3.绘制图形
    CGContextFillPath(ctx);
    UIImage *image = [UIImage imageNamed:@"floatBtn_cancel"];
    [image drawAtPoint:CGPointMake((self.bounds.size.width + kLeft_Gap-image.size.width)/2, (self.bounds.size.height-image.size.height)/2)];//保持图片大小在point点开始画图片，可以把注释去掉看看
    //设置文字居中显示
    NSMutableParagraphStyle*style = [[NSMutableParagraphStyle alloc]init];
    style.alignment=NSTextAlignmentCenter;
    [@"取消浮窗" drawInRect:CGRectMake(kLeft_Gap,(self.bounds.size.height + image.size.height)/2 + 5,self.bounds.size.width-kLeft_Gap,40)withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor colorWithRed:0.98 green:0.92 blue:0.90 alpha:1.00]}];
    
    
}


@end
