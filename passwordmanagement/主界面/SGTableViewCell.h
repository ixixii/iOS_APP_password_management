//
//  SGTableViewCell.h
//  passwordmanagement
//
//  Created by beyond on 2019/09/08.
//  Copyright © 2019 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SGTableViewCell : UITableViewCell
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_id;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_accounttype;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_account;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_loginpassword;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_paypassword;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_usedpassword;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_username;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_telephone;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_email;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_securityemail;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_securityquestion;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_loginby;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_loginurl;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_website;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_shareurl;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_ipaddress;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_cardno;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_cardaddress;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_billdate;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_paydate;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_createtime;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_updatetime;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_expiredate;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_isvip;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_isvpn;
//
@property (weak, nonatomic) IBOutlet UILabel *xib_label_remark;

- (instancetype)inflateCellWithModel:(AccountModel *)model;
+ (instancetype )tableViewCell;

@end

NS_ASSUME_NONNULL_END
