//
//  AccountModel.h
//  passwordmanagement
//
//  Created by beyond on 2019/10/01.
//  Copyright © 2019 beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface AccountModel : NSObject
// int 11
@property (nonatomic,assign) NSInteger ID;
// varchar255, 用户id 这个至关重要,首先根据app传来的sessionid,查出userid,再根据userid查相应的帐号列表
@property (nonatomic,copy) NSString *userid;
// 类型 qq
@property (nonatomic,copy) NSString *accounttype;
// 帐号 308829827
@property (nonatomic,copy) NSString *account;
// 登录密码 6*7圈圈
@property (nonatomic,copy) NSString *loginpassword;
// 登录密码 6*7圈圈
@property (nonatomic,copy) NSString *paypassword;
// 用过的密码: 保存用过/修改过的旧密码
@property (nonatomic,copy) NSString *usedpassword;
// 用户名 beyond
@property (nonatomic,copy) NSString *username;
// 注册手机号 166*67
@property (nonatomic,copy) NSString *telephone;
// 注册邮箱 308829827@qq.com
@property (nonatomic,copy) NSString *email;
// 安全邮箱 null,找回密码用
@property (nonatomic,copy) NSString *securityemail;
// 密保问题和答案: whoareyoubrucelee
@property (nonatomic,copy) NSString *securityquestion;
// 登录方式: 使用 手机号/用户名/email/qq/weixin 登录,后面跟具体的号码
@property (nonatomic,copy) NSString *loginby;
// 登录地址:网站/网银/后台 用
@property (nonatomic,copy) NSString *loginurl;
// 网址: http://308829827.qzone.qq.com,官网
@property (nonatomic,copy) NSString *website;
// 推广链接: 分享注册用
@property (nonatomic,copy) NSString *shareurl;
// 登录ip: 192.168.1.1,服务器用
@property (nonatomic,copy) NSString *ipaddress;
// 卡号 null,银行卡用
@property (nonatomic,copy) NSString *cardno;
// 开户地: 湖南衡阳,银行卡用
@property (nonatomic,copy) NSString *cardaddress;
// varchar20,账单日,信用卡/花呗
@property (nonatomic,copy) NSString *billdate;
// varchar20,付款日,信用卡/花呗
@property (nonatomic,copy) NSString *paydate;
// varchar20,    注册日期: 20190910
@property (nonatomic,copy) NSString *createtime;
// varchar20,    更新日期: 20190912,最近一次更新字段的时间
@property (nonatomic,copy) NSString *updatetime;
// varchar20,    过期日期: 20200922,信用卡/帐号/密码/VIP的过期时间
@property (nonatomic,copy) NSString *expiredate;
// 是不是VIP: 视频会员用
@property (nonatomic,copy) NSString *isvip;
// 是否需要VPN,默认为否
@property (nonatomic,copy) NSString *isvpn;
// 备注: 没有的字段使用备注
@property (nonatomic,copy) NSString *remark;
@end

NS_ASSUME_NONNULL_END
