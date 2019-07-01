//
//  TLHTMLStrVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLHTMLStrVC.h"
#import <WebKit/WebKit.h>

@interface TLHTMLStrVC ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TLHTMLStrVC

//    ('aboutus','关于我们');
//    ('reg_protocol','注册协议');

//    ('treasure_rule','夺宝玩法介绍');
//    ('treasure_statement','夺宝免责申明');

//    ('fyf_rule','发一发玩法介绍');

//    ('fyf_statement','发一发免责申明');
//    ('yyy_statement','摇一摇免责申明');

//    ('yyy_rule','摇一摇玩法介绍');

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:_titleStr];
    
    [self requestWebInfo];
    
}

- (void)requestWebInfo {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"807717";
    
    switch (self.type) {
            
        case ZHHTMLTypeAboutUs: {
            
            http.parameters[@"ckey"] = @"cswDescription";
            
        } break;
            
        case ZHHTMLTypeRegProtocol: {
            
            http.parameters[@"ckey"] = @"cswRule";
            
        } break;
            
        case ZHHTMLTypeDBIntroduce: {
            http.parameters[@"ckey"] = @"treasure_rule";
            
        } break;
            
        case ZHHTMLTypeSendBrebireMoneyIntroduce: {
            http.parameters[@"ckey"] = @"fyf_rule";
            
        } break;
            
        case ZHHTMLTypeShakeItOfIntroduce: {
            http.parameters[@"ckey"] = @"yyy_rule";
            
        } break;
            
        case ZHHTMLTypeReword: {
            http.parameters[@"ckey"] = @"cswReward";
            
        } break;
            
    }
    
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        _htmlStr = responseObject[@"data"][@"note"];
        
        [self initWithWebView];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)initWithWebView {
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) configuration:wkConfig];
    [self.view addSubview:webV];
    webV.navigationDelegate = self;
    
    
    _webView = webV;
    
//    NSString *styleStr = @"<style type=\"text/css\"> *{ font-size:30px;}</style>";

    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 20, _htmlStr];
    
    [webV loadHTMLString:html baseURL:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [TLAlert alertWithInfo:@"加载失败"];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
