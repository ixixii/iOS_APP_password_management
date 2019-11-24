//
//  BeyondCtrl.h
//  KnowingLife
//
//  Created by xss on 15/8/7.
//  Copyright (c) 2015年 siyan. All rights reserved.
//  专用于：自动布局的scrollView的弹簧效果
//  重点是：lastView（其y是自动计算的），其下方一段动态的VMargin(距离scrollView底部)

#import <UIKit/UIKit.h>

@interface InsertViewCtrl : UIViewController

// 要设置contentSize的height 等于 其height + 1
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// 贴底的按钮上方是一个UIView
@property (weak, nonatomic) IBOutlet UIView *lastView;

// 一段动态的VMargin 距离 底部scrollView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicVConstraint;

@property (weak, nonatomic) IBOutlet UILabel *xib_label_title;


@end
