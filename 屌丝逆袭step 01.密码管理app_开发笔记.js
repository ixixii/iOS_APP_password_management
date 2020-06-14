屌丝逆袭step 01.密码管理app_开发笔记
20190905 22:26
todo list 1: 新建xcode项目,pods初始化 √
gem sources --remove https://rubygems.org/
gem sources --add https://gems.ruby-china.com/
gem sources -l
sudo gem install -n /usr/local/bin cocoapods

参考链接: https://www.jianshu.com/p/ab6411a05bc2

iOS适配 11.3以上

------------

todo list 2: github初始化  √
新建 .gitignore
在里面写上Pods,表示Pods目录不需要git来管理,因为它是pod install自动生成的

git init 

git status 

git add --all

git status 

git commit -m 'iOS 密码管理app 第一次提交'

git remote add origin https://github.com/ixixii/iOS_APP_password_management.git
git push -u origin master

git pull origin master
git push origin master

刷新一下网页,看一下效果

------------

todo list 3: 创建证书,真机调试 √
https://developer.apple.com/account/ios/profile/limited/create

调试用的描述文件
上架用的描述文件

todo list 4: app logo √

todo list 5: app 基本信息填写 √
功能:  1.注册
      2.登录
      3.列表
      4.新增
      5.删除
      6.修改
      7.搜索


todo list 6: 使用testflight进行测试  √
提交代码
git status 
git add —all
git commit -a -m "新增app图标"
git pull origin master
git push origin master

todo list 7: 实现后台接口,crud
数据库建表:
用户表 pwdmgmt_user
userid,username,password,pubtime

// 后期待完善
// 用户信息表 pwdmgmt_userinfo
// userid,telephone,qq,weixin,gender,province,city,district,

PHP接口
接口1: 登录 √
post http://sg31.com/ci/pwdmgmt/login
params: username
params: password

测试帐号 beyond 123456

查询ci框架的版本
system\core\codeigniter.php中可以查看版本常量:
define('CI_VERSION', '2.2.0');
CodeIgniter 主要有 3 个版本：CodeIgniter 3（稳定版）、CodeIgniter 4（开发版）和 CodeIgniter 2（旧版）
ci框架旧版在线文档:
https://codeigniter.org.cn/userguide2/toc.html


下载postman for mac
https://www.getpostman.com/downloads/

pwdmgmt_user表
id int11
userid varchar255 
username varchar255
password varchar255
pubtime varchar20


pwdmgmt_session表
id int11
userid varchar255 
sessionid varchar255
pubtime varchar20

登录接口写完  √
http://sg31.com/ci/pwdmgmt/login
// 登录接口
    public function login(){
        // 如果是get请求,则直接Return
        $isGet = $_SERVER['REQUEST_METHOD'] == 'GET';
        if($isGet){
            $responseArr = array();
            $responseArr['isSuccess'] = 0;
            $responseArr['desc'] = '不支持Get请求';
            echo json_encode($responseArr);
            return;
        }

        // 获取post请求参数username和password
        $username = isset($_POST['username'])? htmlspecialchars($_POST['username']) : '';
        $password = isset($_POST['password'])? htmlspecialchars($_POST['password']) : '';
        $sql = "select username from pwdmgmt_user where username = ?";
        $res = $this->db->query($sql,array($username));
        $count = count($res->result_array());
        if($count > 0){
            // 表示用户名存在,再根据密码查询 
            $sql = "select userid from pwdmgmt_user where username = ? and password = ?";
            $res = $this->db->query($sql,array($username,$password));
            $count = count($res->result_array());
            if($count > 0){
                // 将session存入数据库表中
                $resArr = $res->result_array();
                $userid = $resArr[0]['userid'];

                // 如果登录用户名密码正确
                // 生成唯一的sessionid
                $sessionid = md5(uniqid(md5(microtime(true)),true));
                $pubtime = time();
                // id, userid, sessionid, pubtime
                $sql = "insert into pwdmgmt_session(userid,sessionid,pubtime) values (?,?,?)";
                $B = $this->db->query($sql,array($userid,$sessionid,$pubtime));
                if($B == 1){
                    // 插入成功,将sessionid返回给app
                    // echo $sessionid; // 4f218c219c0a5156c75995d3058fe221
                    $responseArr = array();
                    $responseArr['isSuccess'] = 1;
                    $descArr = array();
                    $descArr['sessionid'] = $sessionid;
                    $descArr['msg'] = '请将sessionid保存到app本地,并且每次请求都带上sessionid';
                    $responseArr['desc'] = $sessionid;
                    echo json_encode($responseArr);
                }
                // app端,登录成功后,将sessionid保存到本地;
                // 每次请求时,带上sessionid;服务端根据sessionid,查出userid,进而查出该用户的数据
                // 退出登录时,/logout接口:将session表中,该userid的sessionid全部清空;并且成功后消除本地的sessionid;
            }else{
                $responseArr = array();
                $responseArr['isSuccess'] = 0;
                $responseArr['desc'] = '密码错误';
                echo json_encode($responseArr);
            }
        }else{
            $responseArr = array();
            $responseArr['isSuccess'] = 0;
            $responseArr['desc'] = '用户不存在';
            echo json_encode($responseArr);
        }
    }

退出登录接口  √
http://sg31.com/ci/pwdmgmt/logout
// 退出登录接口
    public function logout(){
        // 如果是get请求,则直接Return
        $isGet = $_SERVER['REQUEST_METHOD'] == 'GET';
        if($isGet){
            $responseArr = array();
            $responseArr['isSuccess'] = 0;
            $responseArr['desc'] = '不支持Get请求';
            echo json_encode($responseArr);
            return;
        }

        // app提交过来的post请求中有sessionid
        $sessionid = isset($_POST['sessionid'])? htmlspecialchars($_POST['sessionid']) : '';
        // 根据sessionid查出userid,再根据userid更新所有sessionid为空
        $sql = "select userid from pwdmgmt_session where sessionid = ?";
        $res = $this->db->query($sql,array($sessionid));
        $arr = $res->result_array();
        if(count($arr) > 0){
            // 查到了登录的用户
            $userid = $arr[0]['userid'];
            $sql = "update pwdmgmt_session set sessionid = '' where userid = ?";
            $b = $this->db->query($sql,array($userid));
            if($b == 1){
                // 注销成功
                // app清除本地的sessionid
                /*
                {
                    "isSuccess":"1",
                    "desc":"注销成功,请将app本地的sessionid清空掉"
                }
                */
                $responseArr = array();
                $responseArr['isSuccess'] = 1;
                $responseArr['desc'] = '注销成功,请将app本地的sessionid清空掉';
                echo json_encode($responseArr);
            }
            
        }else{
            $responseArr = array();
            $responseArr['isSuccess'] = 0;
            $responseArr['desc'] = '未查到使用该session的登录用户';
            echo json_encode($responseArr);
        }

    }

写app界面
1. 主界面 参照testflight
根控制器是导航控制器
导航控制器的rootViewController是一个列表

右上方是一个 登录按钮 / 添加帐号按钮(登录后出现) √

左上方是一个搜索按钮(登录后,并且列表的值超过8条时出现)

1.1 表格顶部tableViewHeaderView参考testFlight
headerView的右方是一个个人头像 √
点击头像进入个人中心,底部有:注销按钮

1.2 headerView的左边是一个大文字: 帐号 √

2. 登录界面  √
登录请求,post,同步的
修改info.plist,使用app支持http请求

<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>

3. 个人中心界面 √
顶部有一个大Logo
中间有一个用户名 v1.0 build3
底部有一个退出按钮

点击 退出按钮时,发送post请求
清除本地sessionid
发送通知
回到主界面

4. 主界面cell定制

5. 主界面获取帐号列表 
接口3: 查询帐号列表
==============================
建表 pwdmgmt_account

id,int11, 	id 1, 
userid, varchar255, 用户id 这个至关重要,首先根据app传来的sessionid,查出userid,再根据userid查相应的帐号列表
accounttype,	类型 qq, 
account,	帐号 308829827,

loginpassword,	登录密码 6*7圈圈,
paypassword,	支付密码 6*7,
usedpassword,	用过的密码: 保存用过/修改过的旧密码


username,	用户名 beyond,
telephone,	注册手机号 166*67,

email,	注册邮箱 308829827@qq.com,
securityemail,	安全邮箱 null,找回密码用
securityquestion,	密保问题和答案: whoareyoubrucelee,

loginby,	登录方式:使用手机号/用户名/email/qq/weixin登录,后面跟具体的号码
loginurl,   登录地址:网站/网银/后台 用
website,	网址: http://308829827.qzone.qq.com,官网
shareurl,	推广链接: 分享注册用,
ipaddress,	登录ip: 192.168.1.1,服务器用

cardno,	卡号 null,银行卡用
cardaddress,	开户地: 湖南衡阳,银行卡用

billdate,varchar20,账单日,信用卡/花呗
paydate,varchar20,付款日,信用卡/花呗

createtime,varchar20,	注册日期: 20190910,
updatetime,varchar20,	更新日期: 20190912,最近一次更新字段的时间
expiredate,varchar20,	过期日期: 20200922,信用卡/帐号/密码/VIP的过期时间

isvip,	是不是VIP: 视频会员用,
isvpn	是否需要VPN,默认为否

remark	备注: 没有的字段使用备注




==============================
id
userid
accounttype
account

loginpassword
paypassword
usedpassword

username
telephone

email
securityemail
securityquestion

loginby
loginurl
website
shareurl
ipaddress

cardno
cardaddress

billdate
paydate

createtime
updatetime
expiredate

isvip
isvpn

usedpassword
remark




---------
约定
如果值有多个,使用逗号分隔
如果值有名称,使用|分隔
例如:
网站: 百度|www.baidu.com,腾讯|www.qq.com

5.1 建表 √

5.2 加一条数据 √
INSERT INTO  `pwdmgmt_account` (  `ID` ,  `accounttype` ,  `account` ,  `loginpassword` ,  `paypassword` ,  `username` ,  `telephone` ,  `email` , `securityemail` ,  `securityquestion` ,  `loginby` ,  `loginurl` ,  `website` ,  `shareurl` ,  `ipaddress` ,  `cardno` ,  `cardaddress` ,  `billdate` ,  `paydate` , `createtime` ,  `updatetime` ,  `expiredate` ,  `isvip` ,  `isvpn` ,  `usedpassword` ,  `remark` ) 
VALUES (
'1',  'QQ',  '308829827',  '1*8圈圈',  '5*8',  'beyond',  '157*67',  '308829827@qq.com',  '密保邮箱忘了',  '密保问题忘了',  '使用QQ号登录,308829827', '登录地址为各平台的QQ软件',  '网址用QQ官网',  'QQ二维码名片链接',  '服务器用的ip地址',  '银行卡用的',  '银行卡开户行',  '账单日,信用卡/花呗',  '付款日,信用卡/花呗', '1569835767',  '1569835767',  '信用卡/帐号/密码/VIP的过期日期',  '不是VIP',  '不需要VPN', NULL ,  '备注'
);

5.3 写查询接口
app发送查询请求时,将sessionid发送给服务器
服务器获取sessionid后,根据sessionid从表中查询出当前已经登录的用户userid
然后,拿着userid去表中查询出所有的帐号信息,返回给app端
接口名称

http://sg31.com/ci/pwdmgmt/list √



5.4 写APP列表界面,请求后台接口,并展示后台接口返回的数据


5.5 写新增接口


5.6 写APP新增界面
app发送新增记录请求时,将sessionid一并传给服务器
服务器获取sessionid后,根据sessionid从表中查询出当前已经登录的用户userid
然后,将userid和app提交过来的数据,一并存入数据库


5.6 写修改接口


5.6 写APP修改界面(先根据id查询所有字段进行数据回显)



===========
phpmyadmin里MySQL字符集:cp1252 West European (latin1) ，解决乱码问题
使用虚拟主机空间上的phpmyadmin操作数据库的时候，
如果看到phpmyadmin首页上显示的MySQL 字符集为cp1252 West European (latin1)，当我们导入数据时就会出现乱码，

解决的方法是：
在phpmyadmin首页的右边有个Language选项，
把默认的中文 - Chinese simplified-gb2312
改成 中文 - Chinese simplified，
则左边的MySQL 字符集会变成UTF-8 Unicode (utf8) ，乱码问题得到解决！

补充一句: 在插入数据前,先将My SQL的连接校对 也改成 utf8_general_ci,再插入数据
===========

+ (NSString *)timeStringFromTimeStamp:(NSString *)timeStampStr
{
    // 如果本身是: 2019-10-02 09:10:12格式,那么直接return
    if([timeStampStr containsString:@":"]){
        return timeStampStr;
    }
    NSTimeInterval _interval=[timeStampStr doubleValue] / 1.0;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *tmpTimeStr = [objDateformat stringFromDate: date];
    return tmpTimeStr;
}

插入一句: 如果取消apple id的订阅?
答: 设置-iTunes Store与App Store-查看AppleID-订阅

----------
// 生成唯一的sessionid
$sessionid = md5(uniqid(md5(microtime(true)),true));
1d03c7a1189f4f428df0377ce505bbc0
1867c94994da18e28fe0087cef9fd26e                

7. 主界面支持上拉加载更多,和下拉刷新  √
未登录时, 下拉刷新时,sessionid传递为空,后台返回错误提示信息: 请登录
app前端,弹出登录控制器 以及 错误信息

todo list 8: 实现app前台界面
1. 登录界面 √
2. 列表 √
3. 搜索 √
3.1 类似微信的搜索控制器,UISearchController (暂时未使用 优雅搜索控制器, 原因是还不会)
3.2 php接口 √ (post参数中,增加了一个querystr)
3.3 app前端 √ (输入关键字时,重新查询)

4. 删除 (功能非必须, 可以暂时不做)

5. 添加 
6. 修改

todo list 9: 上架appstore

todo list 10: 实现web前台界面

todo list 11: 变现(插入alimama广告 or 转让app)



提交代码
git status 
git add —all
git commit -a -m "优化未登录时,下拉刷新后的交互效果,弹出错误提示和登录控制器"
git pull origin master
git push origin master

提交代码 20191124
git status 
git add —all
git commit -a -m "新增:搜索功能(虽支持模糊查询,但是匹配字段不全,还需再优化)"
git commit -a -m "新增:搜索功能(补充后台php文件)"
git commit -a -m "删除不必要的注释"
git commit -a -m "搜索功能 全字段 模糊匹配"
git pull origin master
git push origin master

accounttype	varchar(255)			
account	varchar(255)			
loginpassword	varchar(255)			
paypassword	varchar(255)			
username	varchar(255)			
telephone	varchar(255)			
email	varchar(255)			
securityemail	varchar(255)			
securityquestion	varchar(255)			
loginby	varchar(255)			
loginurl	varchar(255)			
website	varchar(255)			
shareurl	varchar(255)			
 
ipaddress	varchar(255)			
cardno	varchar(255)			
cardaddress	varchar(255)			
billdate	varchar(255)			
paydate	varchar(255)		

createtime	varchar(255)			
updatetime	varchar(255)			

expiredate	varchar(255)			
isvip	varchar(255)			
isvpn	varchar(255)			
usedpassword	varchar(255)			
remark	varchar(512)
--------------------
userid     varchar255 无输入,自动生成
createtime varchar255 无输入,自动生成
updatetime varchar255 无输入,自动生成

提交代码
git status 
git add —all
git commit -a -m "app端,完成新增帐号界面的UI搭建"
git pull origin master
git push origin master

-------------------
ID SQL自动生成,不用管

useid
accounttype
account
loginpassword
paypassword
username
telephone
email
securityemail
securityquestion
loginby
loginurl
website
shareurl
 
ipaddress
cardno
cardaddress
billdate
paydate

createtime PHP代码自动生成
updatetime PHP代码自动生成

expiredate
isvip
isvpn
usedpassword
remark

提交代码
git status 
git add —all
git commit -a -m "完成插入功能"
git pull origin master
git push origin master

// todo list 0: 过期日期, expiredate插入后, 显示有问题 √

// todo list 1: 新增完成后, 关闭控制器, 刷新列表界面 √
todo list 2: 删除接口 √
APP界面上: 侧滑删除 √
PHP后台上: 删除接口 √


创建时, 创建时间为ios的NSDate转成NSString
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    bodyString = [NSString stringWithFormat:@"%@&createtime=%@", bodyString, [formatter stringFromDate:[NSDate date]]];

创建时, 修改时间为空


提交代码
git status 
git add —all
git commit -a -m "优化插入时,创建时间字段;完成侧滑删除功能"
git pull origin master
git push origin master

----------------------

todo list 1: 后台,新增 修改接口 √

todo list 2: 点击 cell, 进入修改界面(即原来的创建界面), 并进行数据回显
保存时,调用update修改接口 √
注意: 更新记录时,必须指定ID,不然就全部更新了


提交代码
git status 
git add —all
git commit -a -m "新增: 注册功能"
git pull origin master
git push origin master


----------------------
1. 注册帐号功能
点击登录按钮, 
将用户名username, 密码password提交到后台

后台首先查询表: pwdmgmt_user表
select * from pwdmgmt_user where username = ?

如果找到了, 再根据密码, 进行登录
如果没有找到, 生成userid, 自动将username和password插入一条记录


2. 异步请求




上传app报错（Unable to download a software component: com.apple.transporter.mediatoolkit/1.13.0）
查询后：
第一种：

报错信息：出现错误：
A downloaded software component is corrupted and will not be used.
解决方法：
打开文件夹：
/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/itms/bin/iTMSTransporter

双击iTMSTransporter，会重新下载图中的2个jar文件，正常执行完，重新上传包即可。
------------------------
2020-02-23 国际化
参考：https://www.cnblogs.com/yanzheng216/p/8674722.html

1.App名称国际化
1.1 删除info.plist中的Bundle display name
1.2 project->info->Localizations添加对应语言
1.2 新建InfoPlist.strings
1.3 点击右边的Localize...
1.4 勾选语言
1.5 分别输入：
CFBundleDisplayName = "Account Mgmt";
CFBundleDisplayName = "帐号管理";

2. storyboard文件国际化
2.1 搜索.strings文件 
2.2 照猫画虎添加英文

3. cell xib中文化国际化
3.1 点击Label上的文字，直接Localize,选择Base
3.2 勾选语言:中文 与 英文
3.2 展开xib，修改文本

4. 代码中的文字 国际化
4.1 新建Localizable.strings文件 
4.2 点击Localizable.strings文件右侧的Localiza...
4.3 勾选所要支持的语言
4.4 定义
"i18n_login" = "登陆"
4.5 使用
	NSString *nameStr= NSLocalizedString(@"i18n_login", nil);  //获取配置语言文字

	NSLocalizedString(@"i18n_modifyaccount", nil)

When you log in, you agree to the license agreement
《许可协议》

"i18n_login" = "Log In";
"i18n_accountType" = "Account Type";

"i18n_login" = "登录";
"i18n_accountType" = "帐号类型";

---------------
v1.1提交报错：
ITMS-90745: Invalid Toolchain
Xcode or SDK that is not yet supported.

----------------
1. App名称国际化


2. 关键字

3. 模客
http://mock-api.com/app.html#!/rule-editor?mid=10443
3.1 获取目标url
ACCOUNTMGMT_GET_CONFIG
GET /api/v1/config

http://mock-api.com/ZgBZdkgB.mock/api/v1/config
{
"ison":"0",
"url": "http://www.baidu.com"
}

3.2

4. Web升级版控件 


----------------
appstore上面，itunesconnect
1.2版本
版本信息 -> 新增：本地化英文

关键词：
Password mgmt, Account mgmt,Password management, Account management,account password,accout,accont

App描述：
Use this account management app, It is very convenient for you to save、view、 modify and search all your accounts and passwords.
At the same time, dozens of relevant information can be saved for each account.
Powerful fuzzy search can help you quickly find a specific account among hundreds of accounts according to any field.


关键词 所有候选项：
拉伯配资、股票、股票配资、配资、炒股、 股票交易 、配资平台 、配资开户 、配资软件 、炒股开户 、炒股软件、 股票开户、 股票软件、赤盈、环球、杜德、启天、丰诺、迈亿、海智投、拉伯万宝、金鼎配资、场外配资、股票数据查询、策略行情、赤赢、环球配资

关键词：
账号管理,密码管理,账号薄,密码薄,賬號,密碼,賬號密碼,账号密码,密码箱,账号密码助手,密码本,账号本,管理密码,密码管理器,密码箱,配资,数据查询,拉伯配资,策略行情,配资开户,环球,场外配资

App描述：
使用此帐户管理应用程序，您可以非常方便地保存、查看、修改和搜索所有帐户和密码。
同时，每个账户都可以保存几十条相关信息。
强大的模糊搜索功能可以帮助您根据任何字段在数百个帐户中快速找到特定的帐户。

--------------
新增：日文国际化
1.App名称国际化
1.2 project->info->Localizations添加对应语言
1.2 新建InfoPlist.strings
1.3 点击右边的Localize...
1.4 勾选语言
1.5 分别输入：
CFBundleDisplayName = "Account Mgmt";
CFBundleDisplayName = "帐号管理";
CFBundleDisplayName = "パスワード   アカウント管理";


2. storyboard文件国际化
2.1 搜索.strings文件 
2.2 照猫画虎添加英文

---------------
审核期内:
不发请求

// 日期差(投稿日期)
+ (NSInteger)daySpanFromUploadDateString:(NSString *)date {
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

 是否在审核期间
+ (BOOL)isDuringAPPCheckDays
{
    NSInteger daySpan = [SGTools daySpanFromUploadDateString:[NSString stringWithFormat:@"%@ 11:11:11",kAppUploadYYMMDD]];
//    NSLog(@"sg__dayspan__%ld",(long)daySpan);
    if (daySpan < kAppCheckDays) {
        return YES;
    }else{
        return NO;
    }
}

// YYYY-MM-DD  必须是两位
#define kAppUploadYYMMDD @"2019-03-10"

// app提交至通过审核的天数
//#define kAppCheckDays 7

-----------------------
good_注册美国appleid 
1. 打开虚拟美国地址生成网站（http://www.haoweichi.com/Index/custom_result）
2. 打开苹果官方注册地址（https://link.jianshu.com/?t=https%3A%2F%2Fappleid.apple.com%2Faccount%23%21%26page%3Dcreate）
   邮箱推荐用gmail
3. 填写好资料以后点击继续输入邮箱收到的验证码点击确认
4. 新页面里，“添加付款方式即bill地址”
   支付方式还是None

5. 手机开vpn（HotspotShield），
   登陆appstore
   email和密码
   支付方式选择None,完成
-----------------------
虚拟地址生成器
http://www.haoweichi.com/Index/custom_result

全名: Larry Ruelas

性别：male

Firstname：Larry
Lastname：Ruelas

称呼：Mr.

生日：2/25/1994
州：CA
街道地址：3520 Rhode Island Avenue
城市：LOS ANGELES
电话：202-359-7671
邮编：90001
州全称：California

 登陆appstore的邮箱：beyond5**7@gmail.com。
 登陆appstore的密码：**********

 Question1: 第1次坐飞机：**
 Question2: 第1辆车型号：**
 Question3: 第1张专辑：**

// SSN社会保险号：578-94-6428
// 职位（职称）：Cost estimator
// 所属公司：Egghead Software
// 身高：5' 9" （174厘米）
// 体重：240.5磅（109.3千克）

-----------------------
原来要设置地区，才能看到appstore本地化的截图和应用名

没通过审核的界面是这样的，此时是不能修改主要语言的。
通过审核之后是这样的，此时才可以修改主要语言

用户操作系统中设置本地化的语言为中文的法国账号用户，因为在法国地区支持法文, 英文（英国）（按苹果支持语言列表查询），则优先显示排前语言：法文 App Store 。（参考下图）

应用在 AppStore 显示的本地化语言顺序，
如果应用 支持用户设备操作系统中设置本地化的语言，
那么应用在 AppStore 本地化 以操作系统中设置本地化的语言来显示。

如果设置本地化的语言不被应用支持，以用户账号所在地区支持的本地化语言为显示，
如果支持多种，排序在前为准。

如果用户账号所在地区支持的本地化语言不被应用支持，那么以应用设置的主要语言显示。


OS X：
退出 iTunes
前往“系统偏好设置”中的“语言与地区”
添加新的语言，或将所需语言拖放到语言列表的顶部
打开 iTunes
点按“iTunes Store”按钮
滚动到页面底部
点按页面右侧的当前地区图标
选取所需的 App Store 的地区
搜索您的 App，此时应能看到您提供的本地化信息

iOS：
按两次主屏幕按钮，然后将 App Store 扫出屏幕，从而关闭 App Store
前往“设置”>“通用”>“多语言环境”>“语言”
轻按所需的语言
轻按“完成”
打开 App Store 并滚动到页面底部
如果已经登录，则轻按您的 Apple ID，然后轻按“注销”
轻按“登录”
轻按“创建 Apple ID”
选取所需的地区并轻按“下一步”
显示语言将发生变更。如果您不想创建新的 Apple ID，则轻按以新的语言显示的“取消”
搜索您的 app，此时应能看到您提供的本地化信息
要查看原始语言的本地化内容，请重复上述步骤，然后用您现有的 Apple ID 登录。

apple本地化 官方文档
https://help.apple.com/app-store-connect/#/deve6f78a8e2?sub=devb34f436a9
https://help.apple.com/app-store-connect/#/dev656087953?sub=devb34f436a9

1.  所有v1.2 更改为 v1.3  √
2.  更新了一下中国区的截图  √
3.  唤起支付
4.  下载企业签名
5.  推送
6.  彩图视频 再加一种语言
-----------------------





-----------------------
todo list 2: 账号管理马甲包

-----------------------
todo list 3: 开一个新的iMessage应用
24张图P一下


-------------------------
2020 06 14 新增功能：
1. 请求数据回来之后，如果有值Arr，就要通过 JSON序列化 转成 data 到本地 √
2. 先从本地取缓存数据， 通过 JSON序列化 转成Arr; 序列化失败，再去服务器请求数据
3. 下拉刷新时，直接取服务器数据
4. 退出登陆时，要删除缓存在沙盒中的Data文件

这样，当服务器挂掉，或者没有网络的时候，从本地加载缓存的json数据