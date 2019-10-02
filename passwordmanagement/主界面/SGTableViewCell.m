//
//  SGTableViewCell.m
//  passwordmanagement
//
//  Created by beyond on 2019/09/08.
//  Copyright © 2019 beyond. All rights reserved.
//

#import "SGTableViewCell.h"

@implementation SGTableViewCell

+ (instancetype )tableViewCell
{
    NSArray *arrayXibObjects = [[NSBundle mainBundle] loadNibNamed:@"SGTableViewCell" owner:nil options:nil];
    return arrayXibObjects[0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)inflateCellWithModel:(AccountModel *)model
{
    self.xib_label_id.text = [NSString stringWithFormat:@"ID: %@",@(model.ID)];
    self.xib_label_accounttype.text = [NSString stringWithFormat:@"账号类型: %@",model.accounttype];
    
    if(model.account.length > 0){
        self.xib_label_account.text = [NSString stringWithFormat:@"账号: %@",model.account];
    }else{
        self.xib_label_account.text = @"";
    }
    
    
    if(model.loginpassword.length > 0){
        self.xib_label_loginpassword.text = [NSString stringWithFormat:@"登录密码: %@",model.loginpassword];
    }else{
        self.xib_label_loginpassword.text = @"";
    }
    
    if(model.paypassword.length > 0){
        self.xib_label_paypassword.text = [NSString stringWithFormat:@"支付密码: %@",model.paypassword];
    }else{
        self.xib_label_paypassword.text = @"";
    }
    
    if(model.usedpassword.length > 0){
        self.xib_label_usedpassword.text = [NSString stringWithFormat:@"曾用密码: %@",model.usedpassword];
    }else{
        self.xib_label_usedpassword.text = @"";
    }
    
    if(model.username.length > 0){
        self.xib_label_username.text = [NSString stringWithFormat:@"用户名: %@",model.username];
    }else{
        self.xib_label_username.text = @"";
    }
    
    if(model.telephone.length > 0){
        self.xib_label_telephone.text = [NSString stringWithFormat:@"手机号: %@",model.telephone];
    }else{
        self.xib_label_telephone.text = @"";
    }
    
    if(model.email.length > 0){
        self.xib_label_email.text = [NSString stringWithFormat:@"邮箱: %@",model.email];
    }else{
        self.xib_label_email.text = @"";
    }
    
    if(model.securityemail.length > 0){
        self.xib_label_securityemail.text = [NSString stringWithFormat:@"安全邮箱: %@",model.securityemail];
    }else{
        self.xib_label_securityemail.text = @"";
    }
    
    if(model.securityquestion.length > 0){
        self.xib_label_securityquestion.text = [NSString stringWithFormat:@"密保问题: %@",model.securityquestion];
    }else{
        self.xib_label_securityquestion.text = @"";
    }
    
    if(model.loginby.length > 0){
        self.xib_label_loginby.text = [NSString stringWithFormat:@"登录方式: %@",model.loginby];
    }else{
        self.xib_label_loginby.text = @"";
    }
    
    if(model.loginurl.length > 0){
        self.xib_label_loginurl.text = [NSString stringWithFormat:@"登录链接: %@",model.loginurl];
    }else{
        self.xib_label_loginurl.text = @"";
    }
    
    if(model.website.length > 0){
        self.xib_label_website.text = [NSString stringWithFormat:@"网站链接: %@",model.website];
    }else{
        self.xib_label_website.text = @"";
    }
    
    if(model.shareurl.length > 0){
        self.xib_label_shareurl.text = [NSString stringWithFormat:@"推广链接: %@",model.shareurl];
    }else{
        self.xib_label_shareurl.text = @"";
    }
    
    if(model.ipaddress.length > 0){
        self.xib_label_ipaddress.text = [NSString stringWithFormat:@"IP地址: %@",model.ipaddress];
    }else{
        self.xib_label_ipaddress.text = @"";
    }
    
    if(model.cardno.length > 0){
        self.xib_label_cardno.text = [NSString stringWithFormat:@"银行卡号: %@",model.cardno];
    }else{
        self.xib_label_cardno.text = @"";
    }
    
    if(model.cardaddress.length > 0){
        self.xib_label_cardaddress.text = [NSString stringWithFormat:@"开户行: %@",model.cardaddress];
    }else{
        self.xib_label_cardaddress.text = @"";
    }
    
    if(model.billdate.length > 0){
        self.xib_label_billdate.text = [NSString stringWithFormat:@"账单日: %@",model.billdate];
    }else{
        self.xib_label_billdate.text = @"";
    }
    
    if(model.paydate.length > 0){
        self.xib_label_paydate.text = [NSString stringWithFormat:@"还款日: %@",model.paydate];
    }else{
        self.xib_label_paydate.text = @"";
    }
    
    if(model.createtime.length > 0){
        self.xib_label_createtime.text = [NSString stringWithFormat:@"创建日期: %@",[SGTableViewCell timeStringFromTimeStamp:model.createtime]];
    }else{
        self.xib_label_createtime.text = @"";
    }
    
    if(model.updatetime.length > 0){
        self.xib_label_updatetime.text = [NSString stringWithFormat:@"更新日期: %@",[SGTableViewCell timeStringFromTimeStamp:model.updatetime]];
    }else{
        self.xib_label_updatetime.text = @"";
    }
    
    if(model.expiredate.length > 0){
        self.xib_label_expiredate.text = [NSString stringWithFormat:@"过期日期: %@",[SGTableViewCell timeStringFromTimeStamp:model.expiredate]];
    }else{
        self.xib_label_expiredate.text = @"";
    }
    
    if(model.isvip.length > 0){
        self.xib_label_isvip.text = [NSString stringWithFormat:@"是否VIP: %@",model.isvip];
    }else{
        self.xib_label_isvip.text = @"";
    }
    
    if(model.isvpn.length > 0){
        self.xib_label_isvpn.text = [NSString stringWithFormat:@"是否VPN: %@",model.isvpn];
    }else{
        self.xib_label_isvpn.text = @"";
    }
    
    
    if(model.remark.length > 0){
        self.xib_label_remark.text = [NSString stringWithFormat:@"备注: %@",model.remark];
    }else{
        self.xib_label_remark.text = @"";
    }
    
    return self;
}

+ (NSString *)timeStringFromTimeStamp:(NSString *)timeStampStr
{
    // 如果本身是: 2019-10-02 09:10:12格式,那么直接return
    if([timeStampStr containsString:@":"] || [timeStampStr containsString:@"-"]){
        return timeStampStr;
    }
    NSTimeInterval _interval=[timeStampStr doubleValue] / 1.0;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *tmpTimeStr = [objDateformat stringFromDate: date];
    return tmpTimeStr;
}
@end
