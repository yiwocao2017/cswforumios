//
//  TLUserLoginVC.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLUserLoginVC.h"
#import "TLUserRegistVC.h"
#import "TLUserForgetPwdVC.h"
#import "TLNavigationController.h"
//#import "ZHHomeVC.h"
#import "ChatManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "BindMobileVC.h"

@interface TLUserLoginVC ()

@property (nonatomic,strong) TLAccountTf *phoneTf;
@property (nonatomic,strong) TLAccountTf *pwdTf;

@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, copy) NSString *mobile;

@end

@implementation TLUserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    [self setUpUI];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //登录成功之后，给予回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxResp:) name:LOGIN_WX_NOTIFICATION object:nil];
    
}

- (void)setUpUI {
    
    
    //    UIScrollView *bgSV = self.bgSV;
    
    CGFloat margin = ACCOUNT_MARGIN;
    CGFloat w = SCREEN_WIDTH - 2*margin;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat middleMargin = ACCOUNT_MIDDLE_MARGIN;
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.layer.cornerRadius = 3;
    bgView.clipsToBounds = YES;
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(margin);
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(2*h + 1);
        make.width.mas_equalTo(w);
        
    }];
    
    //账号
    TLAccountTf *phoneTf = [[TLAccountTf alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    phoneTf.leftIconView.image = [UIImage imageNamed:@"用户名"];
    phoneTf.tl_placeholder = @"请输入手机号码或用户名";
    [bgView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    
    
    //密码
    TLAccountTf *pwdTf = [[TLAccountTf alloc] initWithFrame:CGRectMake(0, phoneTf.yy + 1, w, h)];
    pwdTf.secureTextEntry = YES;
    pwdTf.leftIconView.image = [UIImage imageNamed:@"密码"];
    pwdTf.tl_placeholder = @"请输入密码";
    [bgView addSubview:pwdTf];
    self.pwdTf = pwdTf;
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:kWhiteColor backgroundColor:[UIColor themeColor] titleFont:15.0 cornerRadius:5];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(h);
        make.right.mas_equalTo(-margin);
        make.top.mas_equalTo(bgView.mas_bottom).mas_equalTo(35);
        
    }];
    
    
    //注册
    UIButton *regBtn = [UIButton buttonWithTitle:@"去注册" titleColor:[UIColor themeColor] backgroundColor:kClearColor titleFont:12.0];
    [regBtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    [regBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(38);
        make.width.mas_lessThanOrEqualTo(50);
        make.height.mas_lessThanOrEqualTo(15);
        make.top.mas_equalTo(loginBtn.mas_bottom).mas_equalTo(14);
        
    }];
    
    //找回密码
    UIButton *forgetPwdBtn = [UIButton buttonWithTitle:@"找回密码？" titleColor:[UIColor colorWithHexString:@"#bbbbbb"] backgroundColor:kClearColor titleFont:12.0];
    
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPwdBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdBtn];
    
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(loginBtn.mas_bottom).mas_equalTo(14);
        make.width.mas_lessThanOrEqualTo(80);
        make.height.mas_lessThanOrEqualTo(15);
        
    }];
    
    //判断是否安装微信
    if ([WXApi isWXAppInstalled]) {
        
        UIView *lineView = [[UIView alloc] init];
        
        lineView.backgroundColor = [UIColor colorWithHexString:@"#bbbbbb"];
        
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(-148 - 8);
            
        }];
        
        //其它登陆方式
        UILabel *hintLbl = [UILabel labelWithText:@"其他登录方式" textColor:[UIColor colorWithHexString:@"#bbbbbb"] textFont:12.0];
        
        hintLbl.backgroundColor = self.view.backgroundColor;
        hintLbl.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:hintLbl];
        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(16);
            make.bottom.mas_equalTo(-148);
            
        }];
        
        //
        UIButton *wxLoginBtn = [UIButton buttonWithImageName:@"微信"];
        
        [self.view addSubview:wxLoginBtn];
        [wxLoginBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        wxLoginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        wxLoginBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [wxLoginBtn addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
        [wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(hintLbl.mas_bottom).mas_equalTo(24);
            make.width.height.mas_equalTo(45);
            
        }];
    }
    
    
}

- (void)back {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

//登录成功
- (void)login {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.loginSuccess) {
        self.loginSuccess();
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

- (void)findPwd {
    
    TLUserForgetPwdVC *vc = [[TLUserForgetPwdVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)goReg {
    
    
    [self.navigationController pushViewController:[[TLUserRegistVC alloc] init] animated:YES];
    
}

- (void)goLogin {
    
    [self.view endEditing:YES];
    
    if (![self.phoneTf.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        
        return;
    }
    
    if (!(self.pwdTf.text &&self.pwdTf.text.length > 5)) {
        
        [TLAlert alertWithInfo:@"请输入6位以上密码"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_LOGIN_CODE;
    
    http.parameters[@"loginName"] = self.phoneTf.text;
    http.parameters[@"loginPwd"] = self.pwdTf.text;
    [http postWithSuccess:^(id responseObject) {
        
        [self requesUserInfoWithResponseObject:responseObject];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)requesUserInfoWithResponseObject:(id)responseObject {
    
    NSString *token = responseObject[@"data"][@"token"];
    NSString *userId = responseObject[@"data"][@"userId"];
    
    //1.获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_INFO;
    http.parameters[@"userId"] = userId;
    http.parameters[@"token"] = token;
    [http postWithSuccess:^(id responseObject) {
        
        NSDictionary *userInfo = responseObject[@"data"];
        
        //登录环信
        
        if ([[ChatManager defaultManager] loginWithUserName:userId]) {
            
            //保存用户信息
            [TLUser user].userId = userId;
            [TLUser user].token = token;
            [[TLUser user] saveToken:token];
            //保存用户信息
            [[TLUser user] saveUserInfo:userInfo];
            
            //初始化用户信息
            [[TLUser user] setUserInfoWithDict:userInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
            
            //设置Alias
            [JPUSHService setAlias:userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            
            
        } else {
            
            [TLAlert alertWithInfo:@"登录失败"];
            
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

#pragma mark- 微信登录
- (void)wxLogin {
    
    //微信原生支付
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"csw_app";
    
    [WXApi sendReq:req];
    
//    [self getAuthWithUserInfoFromWechat];
    
    
}

- (void)wxResp:(NSNotification *)notification {

    SendAuthResp *resp = notification.object;
    
    [self requestWxApiWithResp:resp];
}


- (void)getAuthWithUserInfoFromWechat
{
    
//    
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
//        if (error) {
//            
//            [TLAlert alertWithInfo:@"微信登录失败"];
//            
//        } else {
//            
//            UMSocialUserInfoResponse *resp = result;
//            
//            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//            
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.unionGender);
//            
//            TLUser *user = [TLUser user];
//            
//            user.thirdUser.nickname = resp.name;
//            user.thirdUser.iconUrl = resp.iconurl;
//            user.thirdUser.unionGender = resp.unionGender;
//            user.isWXLogin = YES;
//            
//            //调微信接口
//            [self requestWxApiWithResp:resp];
//            
//            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
//        }
//    }];
}

- (void)requestWxApiWithResp:(SendAuthResp *)resp {
    
    CSWWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805151";
    http.parameters[@"code"] = resp.code;
    http.parameters[@"type"] = @"4";
    http.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    http.parameters[@"isRegHx"] = @"1";
    http.parameters[@"smsCaptcha"] = _verifyCode;
    http.parameters[@"mobile"] = [TLUser user].mobile ? [TLUser user].mobile: _mobile;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([responseObject[@"data"][@"isNeedMobile"] isEqualToString:@"1"]) {
            
            //跳到绑定手机号界面
            [TLAlert alertWithInfo:@"请先绑定手机号"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                BindMobileVC *bindMobileVC = [BindMobileVC new];
                
                bindMobileVC.resp = resp;
                
                bindMobileVC.bindMobileBlock = ^(NSString *mobile, NSString *verifyCode) {
                    
                    weakSelf.mobile = mobile;
                    weakSelf.verifyCode = verifyCode;
                    
                };
                
                [self.navigationController pushViewController:bindMobileVC animated:YES];
            });
            
        } else {
        
            [TLUser user].isWXLogin = YES;
            
            [self requesUserInfoWithResponseObject:responseObject];

        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.view endEditing:YES];
    
}

@end
