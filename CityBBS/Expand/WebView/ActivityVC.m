//
//  ActivityVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/1.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ActivityVC.h"
#import <WebKit/WebKit.h>
#import "ShareView.h"
#import "ShareModel.h"

@interface ActivityVC ()<WKScriptMessageHandler,WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ActivityVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithWebView];

}

- (void)initWithWebView {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    
    [config.userContentController addScriptMessageHandler:self name:@"webviewEvent"];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20) configuration:config];
    
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
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    
    topView.backgroundColor = [UIColor themeColor];
    
    [self.view addSubview:topView];
    
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        self.navigationItem.titleView = [UILabel labelWithTitle:string];
    }];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLAlert alertWithError:@"网络不太好"];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
//    NSString *url = navigationAction.request.URL.absoluteString;
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSString *msgName = message.name;
    
    if ([msgName isEqualToString:@"webviewEvent"]) {
        
        [self handleWebViewEvent:message];
    }
    
}

#pragma mark - WebViewEvent

- (void)handleWebViewEvent:(WKScriptMessage*)message {
    
    NSString *bodyStr = message.body;
    
    NSDictionary *messageBody = [NSString deserializeMessageJSON:bodyStr];
    
    NSString *event = messageBody[@"event"];
    
    if ([event isEqualToString:@"share"]) {
        
        ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) shareBlock:^(NSString *title) {
            
            if ([title isEqualToString:@"0"]) {
                
                [TLAlert alertWithSucces:@"分享成功"];
                
            } else {
                
                [TLAlert alertWithError:@"分享失败"];
                
            }
            
        } vc:self];
        
        ShareModel *model = [ShareModel mj_objectWithKeyValues:messageBody[@"params"]];
        
        shareView.shareTitle = model.title;
        shareView.shareDesc = model.desc;
        shareView.shareURL = model.url;
        shareView.shareImgStr = messageBody[@"params"][@"imgUrl"];
        
        [self.view addSubview:shareView];
        
    } else if ([event isEqualToString:@"return"]) {
    
        [self.navigationController popViewControllerAnimated:YES];
    
    } else if ([event isEqualToString:@"wx_pay"]) {
    
    
    } 
    
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
    completionHandler(@"");
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        [TLAlert alertWithMsg:message];
        
    });
    
    completionHandler(YES);
    
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    completionHandler();
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
