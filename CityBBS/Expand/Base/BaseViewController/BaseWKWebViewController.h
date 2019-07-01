//
//  BaseWKWebViewController.h
//  CityBBS
//
//  Created by 蔡卓越 on 17/5/15.
//  Copyright © 2017年 tianlei. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWKWebViewController : BaseViewController

@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic , assign) CGRect webViewFrame;

@property (nonatomic, copy) NSString *titleName;

- (void)wkWebViewRequestWithURL:(NSString *)url;

@end
