//
//  BeyondCtrl.m
//  KnowingLife
//
//  Created by xss on 15/8/7.
//  Copyright (c) 2015年 siyan. All rights reserved.
//

#import "InsertViewCtrl.h"
#import "UIView+Frame.h"
#import "SVProgressHUD.h"
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
- (IBAction)addBtnClicked:(UIButton *)sender
{
    // 长度校验
    if([self isFormValid]){
        [self.view endEditing:YES];
        // 准备参数
        [self prepareToSendRequest];
        // 发送请求
    }
}
- (BOOL)isFormValid
{
    if(self.xib_textField_accounttype.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【帐号类型】长度不能大于255"];
        [self.xib_textField_accounttype becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_account.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【帐号】长度不能大于255"];
        [self.xib_textField_account becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_loginpassword.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【登录密码】长度不能大于255"];
        [self.xib_textField_loginpassword becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_paypassword.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【支付密码】长度不能大于255"];
        [self.xib_textField_paypassword becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_username.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【用户名】长度不能大于255"];
        [self.xib_textField_username becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_telephone.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【手机号】长度不能大于255"];
        [self.xib_textField_telephone becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_email.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【邮箱】长度不能大于255"];
        [self.xib_textField_email becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_securityemail.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【安全邮箱】长度不能大于255"];
        [self.xib_textField_securityemail becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_securityquestion.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【密保问题】长度不能大于255"];
        [self.xib_textField_securityquestion becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_loginby.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【登录方式】长度不能大于255"];
        [self.xib_textField_loginby becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_loginurl.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【登录链接】长度不能大于255"];
        [self.xib_textField_loginurl becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_website.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【网站链接】长度不能大于255"];
        [self.xib_textField_website becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_shareurl.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【推广链接】长度不能大于255"];
        [self.xib_textField_shareurl becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_ipaddress.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【IP地址】长度不能大于255"];
        [self.xib_textField_ipaddress becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_cardno.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【银行卡号】长度不能大于255"];
        [self.xib_textField_cardno becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_cardaddress.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【开户行】长度不能大于255"];
        [self.xib_textField_cardaddress becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_billdate.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【账单日】长度不能大于255"];
        [self.xib_textField_billdate becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_paydate.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【还款日】长度不能大于255"];
        [self.xib_textField_paydate becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_expiredate.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【过期日期】长度不能大于255"];
        [self.xib_textField_expiredate becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_isvip.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【是否VIP】长度不能大于255"];
        [self.xib_textField_isvip becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_isvpn.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【是否VPN】长度不能大于255"];
        [self.xib_textField_isvpn becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_usedpassword.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【曾用密码】长度不能大于255"];
        [self.xib_textField_usedpassword becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_remark.text.length > 255){
        [SVProgressHUD showErrorWithStatus:@"【备注】长度不能大于255"];
        [self.xib_textField_remark becomeFirstResponder];
        return false;
    }
    
    // 必填项校验 -----------
    if(self.xib_textField_accounttype.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"【帐号类型】不能为空"];
        [self.xib_textField_accounttype becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_account.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"【帐号】不能为空"];
        [self.xib_textField_account becomeFirstResponder];
        return false;
    }
    
    if(self.xib_textField_loginpassword.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"【登录密码】不能为空"];
        [self.xib_textField_loginpassword becomeFirstResponder];
        return false;
    }
    
    return true;
}

- (void)prepareToSendRequest
{
    NSURLRequest *request = [self postInsertRequest];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"访问出错：%@", error.localizedDescription);
        return;
    }
    if (data != nil) {
//        [self.tableView.mj_header endRefreshing];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"返回的内容是：%@", string);
        // 将返回的data转成json
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"sg__%@",responseDict);
        NSInteger isSuccess = [[responseDict objectForKey:@"isSuccess"] integerValue];
        if(isSuccess == 0){
            // 弹出失败原因
            NSString *descStr = [responseDict objectForKey:@"desc"];
            [SVProgressHUD showErrorWithStatus:descStr];
            
//            // 未查到使用该session的登录用户
//            // 清空本地sessionid,并弹出登录控制器
//            // 根据用户上次选择的,展示
//            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//            [userDefault setObject:@"" forKey:@"userDefault_sessionid"];
//            [userDefault synchronize];
//
//            // 回调/通知 刷新主界面
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_logoutSuccess" object:nil];
            
//            [self jumpToLoginCtrl];
        }else if(isSuccess == 1){
            [self dismissViewControllerAnimated:YES completion:nil];
            // 登录成功
//            _dictArr = [responseDict objectForKey:@"desc"];
//            _accountArr = [NSMutableArray arrayWithArray:[AccountModel objectArrayWithKeyValuesArray:_dictArr]];
//            [self.tableView reloadData];
        }
    } else {
        NSLog(@"没有接收到数据！");
        [SVProgressHUD showErrorWithStatus:@"请检查网络!"];
    }
}

- (NSURLRequest *)postInsertRequest
{
    NSString *urlStr = @"http://sg31.com/ci/pwdmgmt/accountinsert";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30.0];
    [request setHTTPMethod:@"post"];
    // 根据用户上次选择的,展示
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *sessionid = [userDefault objectForKey:@"userDefault_sessionid"];
    NSString *bodyString = [NSString stringWithFormat:@"sessionid=%@", sessionid];
    NSString *tmpStr = @"";
    
    tmpStr = self.xib_textField_accounttype.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&accounttype=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_account.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&account=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_loginpassword.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&loginpassword=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_paypassword.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&paypassword=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_username.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&username=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_telephone.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&telephone=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_email.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&email=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_securityemail.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&securityemail=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_securityquestion.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&securityquestion=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_loginby.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&loginby=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_loginurl.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&loginurl=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_website.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&website=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_shareurl.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&shareurl=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_ipaddress.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&ipaddress=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_cardno.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&cardno=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_cardaddress.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&cardaddress=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_billdate.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&billdate=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_paydate.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&paydate=%@", bodyString, tmpStr];
    }
    
    // 创建时间
    
    // 修改时间
    
    tmpStr = self.xib_textField_expiredate.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&expiredate=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_isvip.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&isvip=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_isvpn.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&isvpn=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_usedpassword.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&usedpassword=%@", bodyString, tmpStr];
    }
    
    tmpStr = self.xib_textField_remark.text;
    if(tmpStr.length > 0){
        bodyString = [NSString stringWithFormat:@"%@&remark=%@", bodyString, tmpStr];
    }
    
    NSLog(@"数据体字符串：%@", bodyString);
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    return request;
}
@end
