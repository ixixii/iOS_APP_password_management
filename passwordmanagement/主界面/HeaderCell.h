//
//  HeaderCell.h
//  passwordmanagement
//
//  Created by beyond on 2019/09/08.
//  Copyright © 2019 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeaderCell : UITableViewCell
+ (HeaderCell *)headerCell;
+ (CGFloat )cellHeight;
@property (weak, nonatomic) IBOutlet UIButton *xib_headerBtn;

@end

NS_ASSUME_NONNULL_END
