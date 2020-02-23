//
//  PrivacyViewCtrl.m
//  passwordmanagement
//
//  Created by beyond on 2019/12/22.
//  Copyright © 2019 beyond. All rights reserved.
//

#import "PrivacyViewCtrl.h"

@interface PrivacyViewCtrl ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *xib_webView;

- (IBAction)closeBtnClicked:(UIButton *)sender;

@end

@implementation PrivacyViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://vwhm.net/2019/09/06/password_privacy.html"];
    [self.xib_webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0]];
    self.xib_webView.delegate = self;
    
    [self.xib_indicator startAnimating];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.xib_indicator removeFromSuperview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeBtnClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
