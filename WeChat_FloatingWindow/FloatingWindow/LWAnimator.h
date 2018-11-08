//
//  LWAnimator.h
//  WeChat_FloatingWindow
//
//  Created by lwmini on 2018/10/25.
//  Copyright © 2018年 lw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LWAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property(nonatomic,assign)CGRect currentRect;
@end
