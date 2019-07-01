//
//  CSWMallVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWMallVC.h"
#import "GoodsCollectionView.h"
#import "GoodsListModel.h"
#import "CSWGoodsDetailVC.h"

@interface CSWMallVC ()

@property (nonatomic, strong) GoodsCollectionView *goodsCollectionView;

@property (nonatomic, strong) GoodsListModel *goodsListModel;

@end

@implementation CSWMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赏金商城";
        
    [self initCollectionView];

    [self requestMallInfo];
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
    _goodsCollectionView = [[GoodsCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:flowLayout goodsBlock:^(NSInteger index) {
        
        CSWGoodsDetailVC *detailVC = [[CSWGoodsDetailVC alloc] init];
        
        GoodsInfo *goodsInfo = _goodsListModel.list[index];
        
        detailVC.goodCode = goodsInfo.code;
        
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    }];
    
    [self.view addSubview:_goodsCollectionView];
    _goodsCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 5, 10);

    //
    [_goodsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
    
    UILabel *promptLabel = [UILabel labelWithText:@"暂无商品" textColor:kBlackColor textFont:14.0];
    
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
    
    http.code = @"808025";
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"status"] = @"3";
    http.parameters[@"name"] = @"";
    http.parameters[@"category"] = @"";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"10";
    
    http.parameters[@"type"] = @"";
    http.parameters[@"location"] = @"";
    http.parameters[@"orderColumn"] = @"";
    http.parameters[@"orderDir"] = @"";
    http.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    http.parameters[@"systemCode"] = [AppConfig config].systemCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        _goodsListModel = [GoodsListModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        if (_goodsListModel.list.count == 0) {
            
            [self initNoGoodView];
            
        } else {
        
            _goodsCollectionView.goodsListModel = _goodsListModel;
            
            [_goodsCollectionView reloadData];

        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
