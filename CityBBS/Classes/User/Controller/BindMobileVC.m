//
//  BindMobileVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BindMobileVC.h"
#import "TLPwdRelatedVC.h"

@interface BindMobileVC ()

@property (nonatomic,strong) TLTextField *phoneTf;
@property (nonatomic,strong) TLCaptchaView *captchaView;

@end

@implementation BindMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定手机号";
    
    [self initSubviews];
}

- (void)initSubviews {

    CGFloat leftW = 90;

    CGFloat leftMargin = 10;
    
    //手机号
    TLTextField *phoneTf = [[TLTextField alloc] initWithframe:CGRectMake(leftMargin, 20, SCREEN_WIDTH - 2*leftMargin, 45)
                                                    leftTitle:@"手机号"
                                                   titleWidth:leftW
                                                  placeholder:@"请输入手机号"];
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //验证码
    TLCaptchaView *captchaView = [[TLCaptchaView alloc] initWithFrame:CGRectMake(phoneTf.x, phoneTf.yy + 1, phoneTf.width, phoneTf.height)];
    [self.view addSubview:captchaView];
    self.captchaView = captchaView;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    //确认按钮
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(20, captchaView.yy + 30, SCREEN_WIDTH - 40, 44) title:@"绑定"];
    [self.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setTrade:(UIButton *)btn {
    
    TLPwdRelatedVC *tradeVC = [[TLPwdRelatedVC alloc] initWith:TLPwdTypeTradeReset];
    tradeVC.success = ^() {
        
        btn.hidden = YES;
        
    };
    [self.navigationController pushViewController:tradeVC animated:YES];
    
    
}

- (void)sendCaptcha {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = CAPTCHA_CODE;
    http.parameters[@"bizType"] = @"805151";
    http.parameters[@"mobile"] = self.phoneTf.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.captchaView.captchaBtn begin];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)confirm {
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        return;
    }
    
    if (![self.captchaView.captchaTf.text valid] || self.captchaView.captchaTf.text.length < 4 ) {
        [TLAlert alertWithInfo:@"请输入正确的验证码"];
        return;
    }
    
    _bindMobileBlock(self.phoneTf.text, self.captchaView.captchaTf.text);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
