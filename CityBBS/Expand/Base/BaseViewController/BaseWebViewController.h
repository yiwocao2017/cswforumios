//
//  BaseWebViewController.h
//  CityBBS
//
//  Created by 蔡卓越 on 17/5/15.
//  Copyright © 2017年 tianlei. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseWebViewController : BaseViewController

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic , assign) CGRect webViewFrame;

- (void)webViewRequestWithURL:(NSString *)url;

@end
