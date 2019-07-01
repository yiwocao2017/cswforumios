//
//  OrderListVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderListVC.h"
#import "CSWGoodsDetailVC.h"
#import "OrderListCollectionView.h"
#import "OrderListModel.h"

@interface OrderListVC ()

@property (nonatomic, strong) OrderListCollectionView *collectionView;

@property (nonatomic, strong) OrderListModel *orderListModel;

@end

@implementation OrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _orderType = OrderTypePaid;
    
    [self initCollectionView];
    
}

#pragma mark - Init

- (void)initCollectionView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    
    CGFloat w = (SCREEN_WIDTH - 10 - 10*2)/2.0;
    CGFloat imgW = w - 12.5*2;
    CGFloat h = imgW + 12.5 + 50;
    
    flowLayout.itemSize = CGSizeMake(w, h);
    
    CSWWeakSelf;
    //
    _collectionView = [[OrderListCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:flowLayout orderBlock:^(NSInteger index) {
     
        CSWGoodsDetailVC *detailVC = [[CSWGoodsDetailVC alloc] init];
        
        OrderInfo *orderInfo = _orderListModel.list[index];
        
        ProductorderInfo *productorderInfo = orderInfo.productOrderList[0];
    
        
        //        GoodsInfo *goodsInfo = _goodsListModel.list[index];
        //
        detailVC.goodCode = productorderInfo.productCode;
        
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    }];
    
    [self.view addSubview:_collectionView];
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 5, 10);
    
    //
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    
}

- (void)initNoGoodView {
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kClearColor;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(50);
        
    }];
    
    UILabel *promptLabel = [UILabel labelWithText:@"暂无订单" textColor:kBlackColor textFont:14.0];
    
    promptLabel.textAlignment = NSTextAlignmentCenter;
    
    [bgView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data

- (void)requestMallInfo {
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    
    http.code = @"808065";
    http.parameters[@"status"] = _orderType == OrderTypePaid ? @"2": @"4";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"10";
    
    http.parameters[@"type"] = @"";
    http.parameters[@"location"] = @"";
    http.parameters[@"orderColumn"] = @"";
    http.parameters[@"orderDir"] = @"";
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    http.parameters[@"systemCode"] = [AppConfig config].systemCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        _orderListModel = [OrderListModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        if (_orderListModel.list.count == 0) {
            
            [self initNoGoodView];
            
        } else {
            
            _collectionView.orderListModel = _orderListModel;
            
            [_collectionView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
