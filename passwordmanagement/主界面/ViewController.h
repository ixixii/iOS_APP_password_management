//
//  ViewController.h
//  passwordmanagement
//
//  Created by beyond on 2019/09/05.
//  Copyright © 2019 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 查询的关键字
@property (nonatomic,copy) NSString *queryStr;

@end

