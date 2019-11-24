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
git pull origin master
git push origin master