//
//  ViewController.m
//  passwordmanagement
//
//  Created by beyond on 2019/09/05.
//  Copyright © 2019 beyond. All rights reserved.
//

#import "ViewController.h"
#import "SGTableViewCell.h"
#import "HeaderCell.h"

#import "LoginViewCtrl.h"
#import "UserViewCtrl.h"
#import "SVProgressHUD.h"
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SGTableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 右上角的按钮
    [self addRightBtn];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNoti:) name:@"notification_loginSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessNoti:) name:@"notification_logoutSuccess" object:nil];
}
// 处理通知
- (void)loginSuccessNoti:(NSNotification *)noti
{
    // 设置右上角的按钮
    [self addRightBtn];
    [self.tableView reloadData];
}
// 处理通知
- (void)logoutSuccessNoti:(NSNotification *)noti
{
    // 设置右上角的按钮
    [self addRightBtn];
    [self.tableView reloadData];
}


- (void)addRightBtn
{
    // 查看是否已登录
    
    // 如果是未登录,显示 登录按钮
    if(![self isLogin]){
        [self addLoginBtn];
    }else if([self isLogin]){
        // 如果是登录状态,显示 添加帐号的按钮
        [self showAddBtn];
    }
}
- (BOOL)isLogin
{
    NSString *sessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userDefault_sessionid"];
    return sessionid.length > 0;
//    return !(!sessionid || [sessionid isEqualToString:@""]);
}
#pragma mark - 添加登录按钮
- (void)addLoginBtn
{
    CGRect btnFrame = CGRectMake(0, 0, 32, 32);
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:btnFrame];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:kColor(14,89,254) forState:UIControlStateNormal];
    [loginBtn setTitleColor:kColor(255,0,0) forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(jumpToLoginCtrl) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:loginBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)jumpToLoginCtrl
{
    // 弹出登录控制器
    LoginViewCtrl *loginViewCtrl = [[LoginViewCtrl alloc]init];
    [self.navigationController presentViewController:loginViewCtrl animated:YES completion:nil];
}
#pragma mark - 显示 添加帐号按钮
- (void)showAddBtn
{
    CGRect btnFrame = CGRectMake(0, 0, 32, 32);
    UIButton *addBtn = [[UIButton alloc]initWithFrame:btnFrame];
//    [loginBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    [addBtn setTitleColor:kColor(14,89,254) forState:UIControlStateNormal];
    [addBtn setTitleColor:kColor(255,0,0) forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)addBtnClicked:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"将弹出新增帐号控制器"];
}
#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = 2;
    if([self isLogin]){
        n = 7;
    }
    return n;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
//    if(indexPath.row == 0){
//        cell.textLabel.text = @"用户名beyond,密码123456";
//    }else if(indexPath.row == 1){
//        cell.textLabel.text = @"代码和开发笔记的地址在:";
//    }else if(indexPath.row == 2){
//        cell.textLabel.text = @"github.com/ixixii/";
//    }else if(indexPath.row == 3){
//        cell.textLabel.text = @"项目名称:";
//    }else if(indexPath.row == 4){
//        cell.textLabel.text = @"iOS_APP_password_management";
//    }else{
//        cell.textLabel.text = @"主界面和testflight一样";
//    }
    
    if(indexPath.row == 0){
        HeaderCell *headerCell = [HeaderCell headerCell];
        [headerCell.xib_headerBtn addTarget:self action:@selector(headerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return headerCell;
    }else{
        if(indexPath.row == 1){
            cell.textLabel.text = @"用户名beyond,密码123456";
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"代码和开发笔记的地址在:";
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"github.com/ixixii/";
        }else if(indexPath.row == 4){
            cell.textLabel.text = @"项目名称:";
        }else if(indexPath.row == 5){
            cell.textLabel.text = @"iOS_APP_password_management";
        }else{
            cell.textLabel.text = @"主界面和testflight一样";
        }
        return cell;
    }
}
- (void)headerBtnClicked:(UIButton *)btn
{
    if([self isLogin]){
        [self jumpToUserCtrl];
    }else{
        [self jumpToLoginCtrl];
    }
}
- (void)jumpToUserCtrl
{
    [SVProgressHUD showSuccessWithStatus:@"准备弹出个人中心控制器"];
    UserViewCtrl *userViewCtrl = [[UserViewCtrl alloc]init];
    [self.navigationController presentViewController:userViewCtrl animated:YES completion:nil];
}
#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return [HeaderCell cellHeight];
    }else{
        return 60;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1 && ![self isLogin]){
        [self jumpToLoginCtrl];
        return;
    }
    
    if(indexPath.row == 1 && [self isLogin]){
        [self jumpToUserCtrl];
        return;
    }
    
}
@end
