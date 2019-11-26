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
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_accounttype;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_account;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_loginpassword;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_paypassword;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_username;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_telephone;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_email;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_securityemail;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_securityquestion;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_loginby;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_loginurl;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_website;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_shareurl;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_ipaddress;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_cardno;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_cardaddress;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_billdate;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_paydate;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_expiredate;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_isvip;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_isvpn;
@property (weak, nonatomic) IBOutlet UITextField *xib_textField_usedpassword;
@property (weak, nonatomic) IBOutlet UITextView *xib_textField_remark;
@end
