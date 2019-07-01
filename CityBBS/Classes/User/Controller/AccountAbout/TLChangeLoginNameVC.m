//
//  TLChangeLoginNameVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLChangeLoginNameVC.h"
#import "TLAccountTf.h"

@interface TLChangeLoginNameVC ()

@property (nonatomic, strong) TLAccountTf *loginNameTf;
//新登录名
@property (nonatomic, strong) TLAccountTf *freshLoginNameTf;

@end

@implementation TLChangeLoginNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"修改登录名"];
    [self initWithSubviews];
}

- (void)initWithSubviews {

    CGFloat margin = 10;
    CGFloat w = SCREEN_WIDTH - 2*margin;
    CGFloat h = 40;
    
    //提示标签
    UILabel *promptLabel = [UILabel labelWithText:@"登录名只能修改一次,请认真考虑后再做修改" textColor:[UIColor themeColor] textFont:12.0];
    
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(margin);
        make.top.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.height.mas_lessThanOrEqualTo(15);
        
    }];
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.layer.cornerRadius = 3;
    bgView.clipsToBounds = YES;
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(promptLabel.mas_bottom).mas_equalTo(margin);
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(2*h + 1);
        make.width.mas_equalTo(w);
        
    }];
    
    //原登录名
    TLAccountTf *loginNameTf = [[TLAccountTf alloc] initWithFrame:CGRectMake(0, 0, w, h) leftType:LeftTypeTitle];
    loginNameTf.leftLabel.text = @"原登录名";
    loginNameTf.text = [TLUser user].mobile;
    loginNameTf.tl_placeholder = @"请输入原登录名";
    [bgView addSubview:loginNameTf];
    self.loginNameTf = loginNameTf;
//    loginNameTf.keyboardType = UIKeyboardTypeNumberPad;
    loginNameTf.enabled = NO;
    
    //新登录名
    TLAccountTf *newLoginNameTf = [[TLAccountTf alloc] initWithFrame:CGRectMake(0, loginNameTf.yy + 1, w, h) leftType:LeftTypeTitle];
    newLoginNameTf.leftLabel.text = @"新登录名";
    newLoginNameTf.tl_placeholder = @"请输入登录名";
    [bgView addSubview:newLoginNameTf];
    self.freshLoginNameTf = newLoginNameTf;
    
    //保存按钮
    UIButton *saveBtn = [UIButton buttonWithTitle:@"保存" titleColor:kWhiteColor backgroundColor:[UIColor themeColor] titleFont:15.0 cornerRadius:5];
    
    [saveBtn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(margin);
        make.top.mas_equalTo(bgView.mas_bottom).mas_equalTo(35);
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
        
    }];
}

#pragma mark - Events
- (void)clickSave {
    
    if (self.freshLoginNameTf.text.length == 0) {
        
        [TLAlert alertWithMsg:@"请输入登录名"];
        return;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CHANGE_LOGIN_NAME;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"loginName"] = self.freshLoginNameTf.text;
//    http.isShow = @"100";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"保存成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
//        [TLAlert alertWithError:];
    }];

}

@end
