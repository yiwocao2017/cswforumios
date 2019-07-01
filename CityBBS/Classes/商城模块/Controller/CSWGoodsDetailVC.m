//
//  CSWGoodsDetailVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWGoodsDetailVC.h"
#import "GoodDetailView.h"
#import "GoodsInfoModel.h"
#import "CSWGoodsPayVC.h"

@interface CSWGoodsDetailVC ()

@property (nonatomic, strong) GoodDetailView *goodDetailView;

@property (nonatomic, strong) GoodsInfoModel *model;

@end

@implementation CSWGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    [self initGoodDetailView];

    [self getGoodsDetail];
    
}

- (void)getGoodsDetail {

    CSWWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808026";

    http.parameters[@"code"] = _goodCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.model = [GoodsInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        weakSelf.goodDetailView.goodInfoModel = weakSelf.model;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)initGoodDetailView {

    CSWWeakSelf;
    
    _goodDetailView = [[GoodDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) carousel:^(NSInteger index) {
        
    } buyBlock:^(NSString *goodCode) {
        
        [weakSelf commitOrder];
        
    }];
    
    [self.view addSubview:_goodDetailView];
}

//提交订单
- (void)commitOrder {

    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"808050";
    http.parameters[@"productCode"] = self.goodDetailView.goodInfoModel.code;
    http.parameters[@"quantity"] = @"1";
    
    http.parameters[@"pojo"] = [NSMutableDictionary dictionary];
    http.parameters[@"pojo"][@"companyCode"] = [CSWCityManager manager].currentCity.code;
    http.parameters[@"pojo"][@"systemCode"] = @"CD-CCSW000008";
    http.parameters[@"pojo"][@"applyUser"] = [TLUser user].userId;
    http.parameters[@"pojo"][@"reMobile"] = [TLUser user].mobile;
    http.parameters[@"pojo"][@"reAddress"] = @"浙江省杭州市余杭区";
    http.parameters[@"pojo"][@"receiver"] = [TLUser user].nickname;
    
    http.isShow = @"100";
    
    [http postWithSuccess:^(id responseObject) {
        
        CSWGoodsPayVC *payVC = [CSWGoodsPayVC new];
        
        payVC.orderId = responseObject[@"data"];
        payVC.model = self.model;
        
        [self.navigationController pushViewController:payVC animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
