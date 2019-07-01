//
//  DraftsVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "DraftsVC.h"
#import "DraftsTableView.h"
#import "TLComposeVC.h"
#import "DraftsListModel.h"
#import "TLNavigationController.h"

@interface DraftsVC ()<RefreshTableViewDelegate>

@property (nonatomic, strong) DraftsTableView *tableView;

@property (nonatomic, strong) DraftsListModel *model;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, assign) NSInteger limit;

@end

@implementation DraftsVC

- (void)viewWillAppear:(BOOL)animated {

    [self requestDraftsList];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDraftsTableView];
    
    _start = 1;
    
    _limit = 10;
    
}

#pragma mark - Init

- (void)initDraftsTableView {

    CSWWeakSelf;
    
    _tableView = [[DraftsTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain repeatPostBlock:^(NSInteger index) {
        
        TLComposeVC *composeVC = [TLComposeVC new];
        
        composeVC.poseInfo = weakSelf.model.list[index];
        
        composeVC.statusType = ArticleStatusTypeSave;
        
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:composeVC];

        [weakSelf presentViewController:nav animated:YES completion:nil];
        
//        [weakSelf.navigationController pushViewController:composeVC animated:YES];
        
    }];
    
    [_tableView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:YES];
    
    [self.view addSubview: _tableView];
}

- (void)initNoDraftsView {
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kClearColor;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(50);
        
    }];
    
    UILabel *promptLabel = [UILabel labelWithText:@"暂无草稿" textColor:kBlackColor textFont:14.0];
    
    promptLabel.textAlignment = NSTextAlignmentCenter;
    
    [bgView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data

- (void)requestDraftsList {

    CSWWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = ARTICLE_QUERY;
    http.parameters[@"start"] = [NSString stringWithFormat:@"%ld", _start];
    http.parameters[@"limit"] = [NSString stringWithFormat:@"%ld", _limit];
    http.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    http.parameters[@"status"] = @"A";
    http.parameters[@"publisher"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.model = [DraftsListModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        if (weakSelf.model.list.count > 0) {
            
            weakSelf.tableView.draftsListModel = weakSelf.model;

        } else {
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self initNoDraftsView];

            });
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - RefreshTableViewDelegate
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView {
    
    [self requestDraftsList];
}

- (void)refreshTableViewPullUp:(id)refreshTableView {
    
    _limit += 10;
    
    [self requestDraftsList];
}

@end
