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
    self.xib_label_accounttype.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_accountType", nil),model.accounttype];
    
    if(model.account.length > 0){
        self.xib_label_account.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_account", nil),model.account];
    }else{
        self.xib_label_account.text = @"";
    }
    
    
    if(model.loginpassword.length > 0){
        self.xib_label_loginpassword.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_loginpassword", nil),model.loginpassword];
    }else{
        self.xib_label_loginpassword.text = @"";
    }
    
    if(model.paypassword.length > 0){
        self.xib_label_paypassword.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_paypassword", nil),model.paypassword];
    }else{
        self.xib_label_paypassword.text = @"";
    }
    
    if(model.usedpassword.length > 0){
        self.xib_label_usedpassword.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_usedpassword", nil),model.usedpassword];
    }else{
        self.xib_label_usedpassword.text = @"";
    }
    
    if(model.username.length > 0){
        self.xib_label_username.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_username", nil),model.username];
    }else{
        self.xib_label_username.text = @"";
    }
    
    if(model.telephone.length > 0){
        self.xib_label_telephone.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_telephone", nil),model.telephone];
    }else{
        self.xib_label_telephone.text = @"";
    }
    
    if(model.email.length > 0){
        self.xib_label_email.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_email", nil),model.email];
    }else{
        self.xib_label_email.text = @"";
    }
    
    if(model.securityemail.length > 0){
        self.xib_label_securityemail.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_securityemail", nil),model.securityemail];
    }else{
        self.xib_label_securityemail.text = @"";
    }
    
    if(model.securityquestion.length > 0){
        self.xib_label_securityquestion.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_securityquestion", nil),model.securityquestion];
    }else{
        self.xib_label_securityquestion.text = @"";
    }
    
    if(model.loginby.length > 0){
        self.xib_label_loginby.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_loginby", nil),model.loginby];
    }else{
        self.xib_label_loginby.text = @"";
    }
    
    if(model.loginurl.length > 0){
        self.xib_label_loginurl.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_loginurl", nil),model.loginurl];
    }else{
        self.xib_label_loginurl.text = @"";
    }
    
    if(model.website.length > 0){
        self.xib_label_website.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_website", nil),model.website];
    }else{
        self.xib_label_website.text = @"";
    }
    
    if(model.shareurl.length > 0){
        self.xib_label_shareurl.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_shareurl", nil),model.shareurl];
    }else{
        self.xib_label_shareurl.text = @"";
    }
    
    if(model.ipaddress.length > 0){
        self.xib_label_ipaddress.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_ipaddress", nil),model.ipaddress];
    }else{
        self.xib_label_ipaddress.text = @"";
    }
    
    if(model.cardno.length > 0){
        self.xib_label_cardno.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_cardno", nil),model.cardno];
    }else{
        self.xib_label_cardno.text = @"";
    }
    
    if(model.cardaddress.length > 0){
        self.xib_label_cardaddress.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_cardaddress", nil),model.cardaddress];
    }else{
        self.xib_label_cardaddress.text = @"";
    }
    
    if(model.billdate.length > 0){
        self.xib_label_billdate.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_billdate", nil),model.billdate];
    }else{
        self.xib_label_billdate.text = @"";
    }
    
    if(model.paydate.length > 0){
        self.xib_label_paydate.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_paydate", nil),model.paydate];
    }else{
        self.xib_label_paydate.text = @"";
    }
    
    if(model.createtime.length > 0){
        self.xib_label_createtime.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_createtime", nil),[SGTableViewCell timeStringFromTimeStamp:model.createtime]];
    }else{
        self.xib_label_createtime.text = @"";
    }
    
    if(model.updatetime.length > 0){
        self.xib_label_updatetime.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_updatetime", nil),[SGTableViewCell timeStringFromTimeStamp:model.updatetime]];
    }else{
        self.xib_label_updatetime.text = @"";
    }
    
    if(model.expiredate.length > 0){
        self.xib_label_expiredate.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_expiredate", nil),[SGTableViewCell timeStringFromTimeStamp:model.expiredate]];
    }else{
        self.xib_label_expiredate.text = @"";
    }
    
    if(model.isvip.length > 0){
        self.xib_label_isvip.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_isvip", nil),model.isvip];
    }else{
        self.xib_label_isvip.text = @"";
    }
    
    if(model.isvpn.length > 0){
        self.xib_label_isvpn.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_needvpn", nil),model.isvpn];
    }else{
        self.xib_label_isvpn.text = @"";
    }
    
    
    if(model.remark.length > 0){
        self.xib_label_remark.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"i18n_remark", nil),model.remark];
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
