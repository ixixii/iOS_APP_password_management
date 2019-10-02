//
//  UserViewCtrl.m
//  passwordmanagement
//
//  Created by beyond on 2019/09/08.
//  Copyright © 2019 beyond. All rights reserved.
//

#import "UserViewCtrl.h"
#import "SVProgressHUD.h"
@interface UserViewCtrl ()

@end

@implementation UserViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutBtnClicked:(UIButton *)sender {
    // 发请请求Post
    NSURLRequest *request = [self postLogoutRequest];
    NSURLResponse *response = nil;
    NSError *error = nil;
    // 同步请求是一定返回结果后才会继续的！
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
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
        NSString *descStr = [responseDict objectForKey:@"desc"];
        if(isSuccess == 0){
            // 弹出失败原因
            [SVProgressHUD showErrorWithStatus:descStr];
        }else if(isSuccess == 1){
            // 退出成功
            // 清除本地sessionid
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"userDefault_sessionid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 弹出退出成功消息
            // [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"退出成功,%@",descStr]];
            [SVProgressHUD showSuccessWithStatus:@"退出成功"];
            // 回调/通知 刷新主界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_logoutSuccess" object:nil];
            // 关闭控制器
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    } else {
        NSLog(@"没有接收到数据！");
        [SVProgressHUD showErrorWithStatus:@"请检查网络!"];
    }
    
    
    
    // 发出通知,让其他控制器,更新状态
    
    // 回到主界面
    
}

// 建立Post登录请求
- (NSURLRequest *)postLogoutRequest
{
    // 1. 确定地址URL
    NSString *urlString = @"http://sg31.com/ci/pwdmgmt/logout";
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
    NSString *localSessionID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userDefault_sessionid"];
    NSString *bodyString = [NSString stringWithFormat:@"sessionid=%@",localSessionID];
    NSLog(@"数据体字符串：%@", bodyString);
    // 将生成的字符串转换成数据
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@", body);
    // 5) 把数据体设置给请求
    [request setHTTPBody:body];
    // 返回了一个完整的用户登录请求
    return request;
}

@end
