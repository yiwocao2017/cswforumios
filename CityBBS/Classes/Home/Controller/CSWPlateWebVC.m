//
//  CSWPlateWebVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWPlateWebVC.h"
#import <WebKit/WebKit.h>

@interface CSWPlateWebVC ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation CSWPlateWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithWebView];

}

- (void)initWithWebView {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
        
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, -44, kScreenWidth, kScreenHeight - 20) configuration:config];
    
    _webView.navigationDelegate = self;
    
    _webView.UIDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:self.webView];
    
    [self webViewRequestWithURL:_url];
}

- (void)webViewRequestWithURL:(NSString *)url {
    
    NSURL *URL = [NSURL URLWithString:url];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL];
    
    [_webView loadRequest:urlRequest];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD showWithStatus:@"加载中..."];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        self.navigationItem.titleView = [UILabel labelWithTitle:@"帖子详情"];
    }];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLAlert alertWithError:@"网络不太好"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
