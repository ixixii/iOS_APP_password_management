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
headerView的右方是一个个人头像
点击头像进入个人中心,底部有:注销按钮


1.2 headerView的左边是一个大文字: 帐号


2. 登录界面  √
登录请求,post,同步的
修改info.plist,使用app支持http请求

<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>


4. 支持上拉加载更多,和下拉刷新

接口2: 查询列表
接口3: 新增
接口4: 删除 
接口5: 修改

todo list 8: 实现app前台界面
1. 登录界面 √


2. 列表
3. 添加
4. 删除 
5. 修改
6. 搜索


todo list 9: 上架appstore

todo list 10: 实现web前台界面

todo list 11: 变现(插入alimama广告 or 转让app)

