//
//  LWAnimatorView.h
//  WeChat_FloatingWindow
//
//  Created by lwmini on 2018/10/26.
//  Copyright © 2018年 lw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWAnimatorView : UIImageView

- (void)startAnimatingWithView:(UIView *)theView fromRect:(CGRect)fromRect toRect:(CGRect)toRect;

@end
