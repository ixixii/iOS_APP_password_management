<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
header("Content-Type: text/html; charset=utf-8");
// 密码管理app,对应的接口
class Pwdmgmt extends CI_Controller {
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
                    $responseArr['desc'] = $descArr;
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

    // 查询列表接口
    // http://sg31.com/ci/pwdmgmt/list
    public function accountlist(){
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
        // 如果sessionid为空,则报错
        if($sessionid == ""){
            $responseArr = array();
            $responseArr['isSuccess'] = 0;
            $responseArr['desc'] = '请登录';
            echo json_encode($responseArr);
            return;
        }
        // 根据sessionid查出userid,再根据userid查询pwdmgmt_account表中,该userid的所有帐号(后期可分页)
        $sql = "select userid from pwdmgmt_session where sessionid = ?";
        $res = $this->db->query($sql,array($sessionid));
        $arr = $res->result_array();
        if(count($arr) > 0){
            // 查到了登录的用户
            $userid = $arr[0]['userid'];
            // 如果有查询querystr,则进行模糊搜索
            $querystr = isset($_POST['querystr'])? htmlspecialchars($_POST['querystr']) : '';
            if($querystr == ""){
                $sql = "select * from pwdmgmt_account where userid = ? order by ID desc";
                $accountArr = $this->db->query($sql,array($userid))->result_array();
            }else{
                // $sql = "select * from pwdmgmt_account where userid = ? and ()  order by ID desc";
                // $sql = "SELECT * FROM `pwdmgmt_account` WHERE userid = ? and (account like'%?%' or accounttype like '%?%' or username like '%?%' or telephone like '%?%' or email like '%?%' or remark  like '%?%' or website like '%?%' or cardno like '%?%' or cardaddress like '%?%' or loginby like '%?%')";
                $sql = "SELECT * FROM `pwdmgmt_account` WHERE userid = ? and (account like ? or accounttype like ? or username like ? or telephone like ? or email like ? or remark  like ? or website like ? or cardno like ? or cardaddress like ? or loginby like ?)";
                $querystr = '%'.$querystr.'%';
                $accountArr = $this->db->query($sql,array($userid,$querystr,$querystr,$querystr,$querystr,$querystr,$querystr,$querystr,$querystr,$querystr,$querystr))->result_array();
            }
            if(count($accountArr) > 0){
                $responseArr = array();
                $responseArr['isSuccess'] = 1;
                $responseArr['desc'] = $accountArr;
                echo json_encode($responseArr);
                /*
                {
    "isSuccess": 1,
    "accountArr": [{
        "id": "1",
        "userid": "1d03c7a1189f4f428df0377ce505bbc0",
        "accounttype": "QQ",
        "account": "308829827",
        "loginpassword": "1*8\u00c8\u00a6\u00c8\u00a6",
        "paypassword": "5*8",
        "username": "beyond",
        "telephone": "157*67",
        "email": "308829827@qq.com",
        "securityemail": "\u00c3\u00dc\u00b1\u00a3\u00d3\u00ca\u00cf\u00e4\u00cd\u00fc\u00c1\u00cb",
        "securityquestion": "\u00c3\u00dc\u00b1\u00a3\u00ce\u00ca\u00cc\u00e2\u00cd\u00fc\u00c1\u00cb",
        "loginby": "\u00ca\u00b9\u00d3\u00c3QQ\u00ba\u00c5\u00b5\u00c7\u00c2\u00bc,308829827",
        "loginurl": "\u00b5\u00c7\u00c2\u00bc\u00b5\u00d8\u00d6\u00b7\u00ce\u00aa\u00b8\u00f7\u00c6\u00bd\u00cc\u00a8\u00b5\u00c4QQ\u00c8\u00ed\u00bc\u00fe",
        "website": "\u00cd\u00f8\u00d6\u00b7\u00d3\u00c3QQ\u00b9\u00d9\u00cd\u00f8",
        "shareurl": "QQ\u00b6\u00fe\u00ce\u00ac\u00c2\u00eb\u00c3\u00fb\u00c6\u00ac\u00c1\u00b4\u00bd\u00d3",
        "ipaddress": "\u00b7\u00fe\u00ce\u00f1\u00c6\u00f7\u00d3\u00c3\u00b5\u00c4ip\u00b5\u00d8\u00d6\u00b7",
        "cardno": "\u00d2\u00f8\u00d0\u00d0\u00bf\u00a8\u00d3\u00c3\u00b5\u00c4",
        "cardaddress": "\u00d2\u00f8\u00d0\u00d0\u00bf\u00a8\u00bf\u00aa\u00bb\u00a7\u00d0\u00d0",
        "billdate": "\u00d5\u00cb\u00b5\u00a5\u00c8\u00d5,\u00d0\u00c5\u00d3\u00c3\u00bf\u00a8\/\u00bb\u00a8\u00df\u00c2",
        "paydate": "\u00b8\u00b6\u00bf\u00ee\u00c8\u00d5,\u00d0\u00c5\u00d3\u00c3\u00bf\u00a8\/\u00bb\u00a8\u00df\u00c2",
        "createtime": "1569835767",
        "updatetime": "1569835767",
        "expiredate": "\u00d0\u00c5\u00d3\u00c3\u00bf\u00a8\/\u00d5\u00ca\u00ba\u00c5\/\u00c3\u00dc\u00c2\u00eb\/VIP\u00b5\u00c4\u00b9\u00fd\u00c6\u00da\u00c8\u00d5\u00c6\u00da",
        "isvip": "\u00b2\u00bb\u00ca\u00c7VIP",
        "isvpn": "\u00b2\u00bb\u00d0\u00e8\u00d2\u00aaVPN",
        "usedpassword": null,
        "remark": "\u00b1\u00b8\u00d7\u00a2"
    }]
}
                */ 
            }else{
                $responseArr = array();
                $responseArr['isSuccess'] = 1;
                $responseArr['desc'] = $accountArr;
                echo json_encode($responseArr);
            }
        }else{
            $responseArr = array();
            $responseArr['isSuccess'] = 0;
            $responseArr['desc'] = '未查到使用该session的登录用户';
            echo json_encode($responseArr);
        }
    }

    // 录入到where表格中,并且返回另一半的地址
    public function insert(){
        // 用户通过QQ发给我的iadid和tel
        $serveriadid = "450BD576-E0C3-4E12-9492-B57B7E0442EF"; // anxyanxyan_ipad
        $servercode = "anxyanxyan";
        // 获取
        $clientiadid = $_POST["iadid"];
        $clientcode = $_POST["code"];
        $ipaddress = $_SERVER["REMOTE_ADDR"];
         // 时间戳
        $timeStamp = time();
        if ($clientiadid == $serveriadid && $clientcode == $servercode) {
            
            // 成功则插入,返回ok
            // 插入 (REMOTE_ADDR)
                $sql =
                'INSERT INTO sg_app_buy(iadid,tel,pubtime,ipaddress,language)
                VALUES(?,?,?,?,?)';
                
                // $sql = "SELECT * FROM some_table WHERE id = ? AND status = ? AND author = ?";
                
                $B = $this->db->query($sql, array($clientiadid,$clientcode,$timeStamp,$ipaddress,$language));
                if ($B == 1) {
                    # code...
                    // 插入成功,返回ok
                    echo "ok";
                }

        } else {
            // 失败,返回error
            if ($clientiadid != $serveriadid) {
                # code...
                echo "id_error_c:".$clientiadid.",s:".$serveriadid;
            } else {
                # code...
                echo "code_error_c:".$clientcode.",s:".$servercode;
            }
            
            echo "error";
        }
    }
}

/* End of file pwdmgmt.php */
/* Location: ./application/controllers/pwdmgmt.php */