//
//  HeaderCell.m
//  passwordmanagement
//
//  Created by beyond on 2019/09/08.
//  Copyright © 2019 beyond. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (HeaderCell *)headerCell
{
    NSArray *tmpArr = [[NSBundle mainBundle]loadNibNamed:@"HeaderCell" owner:nil options:nil];
    return tmpArr[0];
}
+ (CGFloat )cellHeight
{
    return 80;
}
@end
