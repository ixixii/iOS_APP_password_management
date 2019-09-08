//
//  LoginViewCtrl.m
//  passwordmanagement
//
//  Created by beyond on 2019/09/08.
//  Copyright © 2019 beyond. All rights reserved.
//

#import "LoginViewCtrl.h"
#import "SVProgressHUD.h"
@interface LoginViewCtrl ()

@end

@implementation LoginViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)loginBtnClicked:(UIButton *)sender {
    // 1. 通过自定义的方法返回登录请求
    NSURLRequest *request = [self postLoginRequest];
    // 2. 开始同步连接
    // 同步请求需要几个参数
    // 1) 请求，已经准备好了
    // 2) 响应，所为响应，就是服务器给你的响应
    // 3) 错误，因为网络连接有可能出错。
    // 在写网络访问程序的时候，一定要有出错处理，提醒用户。
    NSURLResponse *response = nil;
    NSError *error = nil;
    // 同步请求是一定返回结果后才会继续的！
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    // 给一个填充错误的地址，有可能会延时网络访问时间
    NSLog(@"访问完成");
    // 3. 获取数据
    // 可能会返回什么数据？
    // 1) 返回请求的结果！解码！！！！！解码成我们认识的字符串
    // 2) 请求出现错误！
    // 3) 返回空数据！
    if (error != nil) {
        NSLog(@"访问出错：%@", error.localizedDescription);
        return;
    }
    if (data != nil) {
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
        }else if(isSuccess == 1){
            // 登录成功
            NSDictionary *descDict = [responseDict objectForKey:@"desc"];
            NSString *sessionid = [descDict objectForKey:@"sessionid"];
            NSString *msgStr = [descDict objectForKey:@"msg"];
            // 保存session到本地
            NSLog(@"sg--");
            // [[NSUserDefaults standardUserDefaults] objectForKey:@""]
            [[NSUserDefaults standardUserDefaults]setObject:sessionid forKey:@"userDefault_sessionid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 弹出登录成功消息
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"登录成功,%@",msgStr]];
            // 回调/通知 刷新主界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_loginSuccess" object:nil];
            // 关闭控制器
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    } else {
        NSLog(@"没有接收到数据！");
        [SVProgressHUD showErrorWithStatus:@"请检查网络!"];
    }
}

#pragma mark - post请求

// 建立Post登录请求
- (NSURLRequest *)postLoginRequest
{
    // 1. 确定地址URL
    NSString *urlString = @"http://sg31.com/ci/pwdmgmt/login";
    NSURL *url = [NSURL URLWithString:urlString];
    // 2. 建立可变请求
    // 1）建立可变请求，是要修改请求，所以要用NSMutableURLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 2) 建立请求超时时间
    [request setTimeoutInterval:5.0];
    // 3) 指定请求方法是“POST”，注意，如果是POST，必须去指定HTTP方法。
    // post字符串不区分大小写，POST
    [request setHTTPMethod:@"post"];
    // 4) 建立请求"数据体"，因为要把这个数据体传送给服务器。
    NSString *bodyString = [NSString stringWithFormat:@"username=%@&password=%@", self.xib_textField_username.text, self.xib_textField_password.text];
    NSLog(@"数据体字符串：%@", bodyString);
    // 将生成的字符串转换成数据
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@", body);
    // 5) 把数据体设置给请求
    [request setHTTPBody:body];
    // 返回了一个完整的用户登录请求
    return request;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
