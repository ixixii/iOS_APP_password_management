//
//  WebViewCtrl.h
//  passwordmanagement
//
//  Created by beyond on 2020/02/23.
//  Copyright © 2020 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WebViewCtrl : UIViewController
//
@property (nonatomic,copy) NSString *url;
//
@property (nonatomic,weak) IBOutlet WKWebView *xib_webView;
@end

NS_ASSUME_NONNULL_END
