//
//  CollectionVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CollectionVC.h"
#import "TLNavigationController.h"
#import "CSWTimeLineCell.h"
#import "CSWLayoutItem.h"
#import "CSWArticleDetailVC.h"
#import "CSWSwitchView.h"
#import "CSWForumVC.h"
#import "CSWArticleModel.h"
#import "TLUserLoginVC.h"

@interface CollectionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *timeLineTableView;
@property (nonatomic, strong) CSWLayoutItem *layoutItem;

@property (nonatomic, strong) NSMutableArray <CSWLayoutItem *>*timeLineLayoutItemRoom;

@property (nonatomic, assign) BOOL isFirst;
//@property (nonatomic, strong) TLNetworking *timelinHttp;
@property (nonatomic, strong) TLPageDataHelper *timeLinePageDataHelper;

@end

@implementation CollectionVC

- (CSWLayoutItem *)layoutItem {
    
    if (!_layoutItem) {
        
        _layoutItem = [[CSWLayoutItem alloc] init];
        _layoutItem.article = [CSWArticleModel new];
    }
    return _layoutItem;
    
}

- (NSMutableArray<CSWLayoutItem *> *)timeLineLayoutItemRoom {
    
    if (!_timeLineLayoutItemRoom) {
        
        _timeLineLayoutItemRoom = [NSMutableArray new];
    }
    
    return _timeLineLayoutItemRoom;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        [self.timeLineTableView beginRefreshing];
        self.isFirst = NO;
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange) name:kCityChangeNotification object:nil];
    
    self.isFirst = YES;
    //顶部有料和论坛的切换
    CGFloat h = 35;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - h, 120, h)];
    headerView.centerX = [UIScreen mainScreen].bounds.size.width/2.0;
    //    headerView.backgroundColor = [UIColor orangeColor];
    
    //时间线table
    self.timeLineTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    self.timeLineTableView.delegate = self;
    self.timeLineTableView.dataSource = self;
    [self.view addSubview:self.timeLineTableView];
    self.timeLineTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无收藏"];
    
    //论坛版块相关
  
    __weak typeof(self) weakSelf = self;
    
#pragma mark- 时间线刷新时间
    TLPageDataHelper *timeLinePageData = [[TLPageDataHelper alloc] init];
    timeLinePageData.code = ARTICLE_COLLECTION_QUERY;
    timeLinePageData.parameters[@"talker"] = [TLUser user].userId;
    
    timeLinePageData.tableView = self.timeLineTableView;
    [timeLinePageData modelClass:[CSWArticleModel class]];
    self.timeLinePageDataHelper = timeLinePageData;
    
    //数据转换
    [timeLinePageData setDealWithPerModel:^(id model){
        
        CSWLayoutItem *layoutItem = [CSWLayoutItem new];
        layoutItem.type = CSWArticleLayoutTypeDefault;
        layoutItem.article = model;
        return layoutItem;
        
    }];
    
    
    //
    [self.timeLineTableView addRefreshAction:^{
        
        [timeLinePageData refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.timeLineLayoutItemRoom = objs;
            [weakSelf.timeLineTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.timeLineTableView addLoadMoreAction:^{
        
        [timeLinePageData loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.timeLineLayoutItemRoom = objs;
            [weakSelf.timeLineTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];

}


- (void)cityChange {
    
    self.timeLinePageDataHelper
    .parameters[@"companyCode"] =[CSWCityManager manager].currentCity.code;
    [self.timeLineTableView beginRefreshing];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //计算
    //    return  self.layoutItem.cellHeight;
    return self.timeLineLayoutItemRoom[indexPath.row].cellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
    
    CSWLayoutItem *layoutItem =  [CSWLayoutItem new];
    
    layoutItem.type = CSWArticleLayoutTypeArticleDetail;
    
    layoutItem.article = self.timeLineLayoutItemRoom[indexPath.row].article;
    //
    //    detailVC.layoutItem = layoutItem;
    detailVC.articleCode = layoutItem.article.code;
    //
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.timeLineLayoutItemRoom.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCell"];
    if (!cell) {
        
        cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCell"];
        
    }
    
    
    //    cell.layoutItem = self.layoutItem;
    cell.layoutItem = self.timeLineLayoutItemRoom[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

@end
