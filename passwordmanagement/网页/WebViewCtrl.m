//
//  WebViewCtrl.m
//  passwordmanagement
//
//  Created by beyond on 2020/02/23.
//  Copyright © 2020 beyond. All rights reserved.
//

#import "WebViewCtrl.h"

@interface WebViewCtrl ()

@end

@implementation WebViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.xib_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.baidu.com"]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
