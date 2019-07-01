//
//  ZHChangeMobileVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLChangeMobileVC.h"
#import "TLPwdRelatedVC.h"

@interface TLChangeMobileVC ()

@property (nonatomic,strong) TLTextField *phoneTf;
@property (nonatomic,strong) TLCaptchaView *captchaView;
//@property (nonatomic,strong) TLTextField *tradePwdTf;

@end

@implementation TLChangeMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat leftW = 90;
    self.title = @"修改手机号";
    CGFloat leftMargin = 10;
    
    //手机号
    TLTextField *phoneTf = [[TLTextField alloc] initWithframe:CGRectMake(leftMargin, 20, SCREEN_WIDTH - 2*leftMargin, 45)
                                                    leftTitle:@"新手机号"
                                                   titleWidth:leftW
                                                  placeholder:@"请输入新手机号"];
    [self.bgSV addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    //验证码
    TLCaptchaView *captchaView = [[TLCaptchaView alloc] initWithFrame:CGRectMake(phoneTf.x, phoneTf.yy + 1, phoneTf.width, phoneTf.height)];
    [self.bgSV addSubview:captchaView];
    self.captchaView = captchaView;
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
//    //支付密码按钮
//    TLTextField *tradePwdTf = [[TLTextField alloc] initWithframe:CGRectMake(0, captchaView.yy  + 1, SCREEN_WIDTH, 50) leftTitle:@"支付密码" titleWidth:90 placeholder:@"请输入支付密码"];
//    tradePwdTf.secureTextEntry = YES;
//    tradePwdTf.isSecurity = YES;
//    [self.view addSubview:tradePwdTf];
//    self.tradePwdTf = tradePwdTf;
    
//    //新手机号
//    TLTextField *newPhoneTf = [[TLTextField alloc] initWithframe:CGRectMake(0, captchaView.yy + 20, SCREEN_WIDTH, 45)
//                                                    leftTitle:@"新手机号"
//                                                   titleWidth:leftW
//                                                  placeholder:@"请输入手机号"];
//    [self.bgSV addSubview:newPhoneTf];
//    
//    //验证码
//    TLCaptchaView *newCaptchaView = [[TLCaptchaView alloc] initWithFrame:CGRectMake(phoneTf.x, newPhoneTf.yy + 1, phoneTf.width, phoneTf.height)];
//    [self.bgSV addSubview:newCaptchaView];
    
    //确认按钮
    UIButton *confirmBtn = [UIButton zhBtnWithFrame:CGRectMake(20, captchaView.yy + 30, SCREEN_WIDTH - 40, 44) title:@"确认修改"];
    [self.bgSV addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    //
//    UIButton *setPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, confirmBtn.yy + 10, SCREEN_WIDTH - 30, 30) title:@"您还未设置支付密码,前往设置->" backgroundColor:[UIColor clearColor]];
//    [self.view addSubview:setPwdBtn];
//    [setPwdBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
//    setPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [setPwdBtn addTarget:self action:@selector(setTrade:) forControlEvents:UIControlEventTouchUpInside];
//    
//    if ([[TLUser user].tradepwdFlag isEqualToString:@"1"]) {
//        setPwdBtn.hidden = YES;
//    }
    
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
    http.parameters[@"bizType"] = USER_CAHNGE_MOBILE;
    http.parameters[@"mobile"] = self.phoneTf.text;

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"验证码已发送,请注意查收"];

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
    
//    if (![self.tradePwdTf.text valid]) {
//        
//        [TLAlert alertWithHUDText:@"请输入支付密码"];
//        return;
//        
//    }

    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CAHNGE_MOBILE;
    http.parameters[@"newMobile"] = self.phoneTf.text;
    http.parameters[@"smsCaptcha"] = self.captchaView.captchaTf.text;
//    http.parameters[@"tradePwd"] = self.tradePwdTf.text;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;

    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"修改成功"];
        [TLUser user].mobile = self.phoneTf.text;
        if (self.changeMobileSuccess) {
            self.changeMobileSuccess(self.phoneTf.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
