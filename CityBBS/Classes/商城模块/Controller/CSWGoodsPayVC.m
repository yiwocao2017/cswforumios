//
//  CSWGoodsPayVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWGoodsPayVC.h"
#import "GoodsPayView.h"

@interface CSWGoodsPayVC ()

@property (nonatomic, strong) GoodsPayView *goodsPayView;

@end

@implementation CSWGoodsPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付";
    [self initGoodsPayView];
    
    [self requestSJBalance];
}

- (void)initGoodsPayView {

    CSWWeakSelf;
    
    _goodsPayView = [[GoodsPayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) payBlock:^{
        //点击支付
        [weakSelf startPay];
    }];
    
    _goodsPayView.model = _model;
    
    [self.view addSubview:_goodsPayView];
}

#pragma mark - Data
//查询赏金余额
- (void)requestSJBalance {

    CSWWeakSelf;
    TLNetworking *sjHttp = [TLNetworking new];
    sjHttp.code = @"802503";
    sjHttp.parameters[@"userId"] = [TLUser user].userId;
    sjHttp.parameters[@"token"] = [TLUser user].token;
    [sjHttp postWithSuccess:^(id responseObject) {
        
        NSArray <NSDictionary *> *arr = responseObject[@"data"];
        [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj[@"currency"] isEqualToString:@"JF"]) {
                
                NSString *moneyStr = [NSString stringWithFormat:@"余额：%@", [obj[@"amount"] convertToRealMoney]];
                
                weakSelf.goodsPayView.balanceLabel.text = moneyStr;
            }
            
        }];
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events

- (void)startPay {

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"808052";
    http.parameters[@"codeList"] = @[_orderId];
    http.parameters[@"payType"] = @"90";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"支付成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];

        });
        
    } failure:^(NSError *error) {
        
        [TLAlert alertWithInfo:@"支付失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
