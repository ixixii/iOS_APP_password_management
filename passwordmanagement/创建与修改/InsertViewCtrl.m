//
//  BeyondCtrl.m
//  KnowingLife
//
//  Created by xss on 15/8/7.
//  Copyright (c) 2015年 siyan. All rights reserved.
//

#import "InsertViewCtrl.h"
#import "UIView+Frame.h"
@interface InsertViewCtrl ()

@end

@implementation InsertViewCtrl
#pragma mark - 动态调整 按钮上方的这段空白距离
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 要设置contentSize的height 等于 其height + 1
    CGFloat vconstant = self.scrollView.height - CGRectGetMaxY(self.lastView.frame) +1;
    
    // 有可能出现负数（当contentSize的Height本身就大于scrollView的Height时）
    if (vconstant > 0) {
        self.dynamicVConstraint.constant = vconstant;
    }
        
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped)];
    [self.xib_label_title addGestureRecognizer:tapReco];
}
- (void)titleTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
