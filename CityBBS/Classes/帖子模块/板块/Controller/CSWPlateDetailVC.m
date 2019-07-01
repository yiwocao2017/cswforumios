//
//  CSWPlateDetailVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWPlateDetailVC.h"
#import "TLNavigationController.h"
#import "TLComposeVC.h"
#import "CSWArticleTypeSwitchView.h"
#import "CSWPlateHeaderView.h"
#import "CSWTimeLineCell.h"
#import "CSWPlateDetailModel.h"
#import "CSWCityManager.h"
#import "CSWArticleDetailVC.h"
#import "CSWSearchVC.h"
#import "ShareView.h"

@interface CSWPlateDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *switchScrollView;

@property (nonatomic, strong) TLTableView *allTableView;
@property (nonatomic, strong) TLTableView *lastTableView;
@property (nonatomic, strong) TLTableView *essenceTableView;


@property (nonatomic, copy) NSArray<CSWLayoutItem *> *allArticleLayouItems;
@property (nonatomic, copy) NSArray<CSWLayoutItem *> *lastArticleLayouItems;
@property (nonatomic, copy) NSArray<CSWLayoutItem *> *essenceArticleLayouItems;


@property (nonatomic, strong) CSWPlateHeaderView *falseHeaderView;
@property (nonatomic, strong) CSWArticleTypeSwitchView *switchView;

@property (nonatomic, assign) BOOL switchBySwitchView;

@property (nonatomic, strong) CSWPlateDetailModel *currentPlateDetailModel;

@property (nonatomic, assign) NSInteger index;

@end

@implementation CSWPlateDetailVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    switch (_index) {
        case 0:
        {
            [self.allTableView beginRefreshing];
        }
            break;
        case 1:
        {
            [self.lastTableView beginRefreshing];
            
        }
            break;
        case 2:
        {
            [self.essenceTableView beginRefreshing];
            
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _index = 0;
    
    //根据plateCode 获取板块信息
    TLNetworking *getPlateHttp = [TLNetworking new];
    getPlateHttp.showView = self.view;
    getPlateHttp.code = @"610046";
    getPlateHttp.parameters[@"code"] = self.plateCode;
    [getPlateHttp postWithSuccess:^(id responseObject) {
        
        //
        
     self.currentPlateDetailModel =  [CSWPlateDetailModel tl_objectWithDictionary:responseObject[@"data"]];
      
        //
        if ([self.currentPlateDetailModel.top isEqual:@0]) {
            //无置顶
            
        } else {
            //有置顶
//            TLNetworking *http = [TLNetworking new];
//            http.showView = self.view;
//            http.code = @"";
//            http.parameters[@""] = <#value#>;
//            http.parameters[@""] = <#value#>;
//            http.parameters[@""] = <#value#>;
//            [http postWithSuccess:<#^(id responseObject)success#> failure:<#^(NSError *error)failure#>];
        
        }
        
        [self setUpUI];
        
        //添加行为
        [self addRefreshAction];
        
        [self.allTableView beginRefreshing];

        NSString *urlStr = [self.currentPlateDetailModel.splate.pic convertImageUrl];
        
        self.title = self.currentPlateDetailModel.splate.name;
        self.falseHeaderView.nameLbl.text = self.currentPlateDetailModel.splate.name;
        self.falseHeaderView.poseNumLabel.text = [NSString stringWithFormat:@"主题：%ld", [self.currentPlateDetailModel.allPostCount integerValue]];
        self.falseHeaderView.todayPoseNumLabel.text = [NSString stringWithFormat:@"今日：%ld", [self.currentPlateDetailModel.todayPostCount integerValue]];
        
        [self.falseHeaderView.plateImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)addRefreshAction {


    __weak typeof(self) weakself = self;
    
    //全部
    TLPageDataHelper *allPageDataHelper = [[TLPageDataHelper alloc] init];
    allPageDataHelper.code = ARTICLE_QUERY;
    allPageDataHelper.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    allPageDataHelper.parameters[@"plateCode"] = self.plateCode;
    allPageDataHelper.parameters[@"status"] = @"BD";
    
    allPageDataHelper.tableView = self.allTableView;
    [allPageDataHelper modelClass:[CSWArticleModel class]];
    [allPageDataHelper setDealWithPerModel:^(id model){
        
        CSWLayoutItem *layoutItem = [CSWLayoutItem new];
        layoutItem.type = CSWArticleLayoutTypeDefault;
        layoutItem.article = model;
        return layoutItem;
        
    }];
    [self.allTableView addRefreshAction:^{
        
        [allPageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.allArticleLayouItems = objs;
            [weakself.allTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.allTableView addLoadMoreAction:^{
        
        [allPageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.allArticleLayouItems = objs;
            [weakself.allTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    
    //最新
    TLPageDataHelper *lastPageDataHelper = [[TLPageDataHelper alloc] init];
    lastPageDataHelper.code = ARTICLE_QUERY;
    lastPageDataHelper.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    lastPageDataHelper.tableView = self.lastTableView;
    [lastPageDataHelper modelClass:[CSWArticleModel class]];
    lastPageDataHelper.parameters[@"plateCode"] = self.plateCode;
    lastPageDataHelper.parameters[@"status"] = @"BD";

    [lastPageDataHelper setDealWithPerModel:^(id model){
        
        CSWLayoutItem *layoutItem = [CSWLayoutItem new];
        layoutItem.type = CSWArticleLayoutTypeDefault;
        layoutItem.article = model;
        return layoutItem;
        
    }];
    [self.lastTableView addRefreshAction:^{
        
        [lastPageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.lastArticleLayouItems = objs;
            [weakself.lastTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.lastTableView addLoadMoreAction:^{
        
        [lastPageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.lastArticleLayouItems = objs;
            [weakself.lastTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    //精华
    TLPageDataHelper *essencePageDataHelper = [[TLPageDataHelper alloc] init];
    essencePageDataHelper.code = ARTICLE_QUERY;
     essencePageDataHelper.parameters[@"location"] = @"B";
    essencePageDataHelper.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    essencePageDataHelper.parameters[@"status"] = @"BD";

    essencePageDataHelper.tableView = self.essenceTableView;
    [essencePageDataHelper modelClass:[CSWArticleModel class]];
    essencePageDataHelper.parameters[@"plateCode"] = self.plateCode;
    [essencePageDataHelper setDealWithPerModel:^(id model){
        
        CSWLayoutItem *layoutItem = [CSWLayoutItem new];
        layoutItem.type = CSWArticleLayoutTypeDefault;
        layoutItem.article = model;
        return layoutItem;
        
    }];
    [self.essenceTableView addRefreshAction:^{
        
        [essencePageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.essenceArticleLayouItems = objs;
            [weakself.essenceTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.essenceTableView addLoadMoreAction:^{
        
        [essencePageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.essenceArticleLayouItems = objs;
            [weakself.essenceTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
}


- (void)setUpUI {

    UIButton *searchBtn = [UIButton buttonWithImageName:@"headline_search"];
    
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *composeBtn = [UIButton buttonWithImageName:@"compose"];
    
    composeBtn.frame = CGRectMake(0, 0, 30, 30);
    
    [composeBtn addTarget:self action:@selector(compose) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *btnArray = @[composeBtn, searchBtn];
    
    [UIBarButtonItem addRightItemArray:btnArray vc:self];
    
    //背景
    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
    [self.view addSubview:self.switchScrollView];
    [self.switchScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.switchScrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.switchScrollView.pagingEnabled = YES;
    self.switchScrollView.delegate = self;
    
    //头部
    self.falseHeaderView = [[CSWPlateHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.view addSubview:self.falseHeaderView];
    self.falseHeaderView.plateImageView.backgroundColor = [UIColor whiteColor];
    
    
    //
    self.switchBySwitchView = NO;
    self.switchView = [[CSWArticleTypeSwitchView alloc] initWithFrame:CGRectMake(0, self.falseHeaderView.yy, self.falseHeaderView.width, 40)];
    self.switchView.itemWidth = 55;
    self.switchView.intervalMargin = 45;
    self.switchView.typeNames = @[@"全部",@"最新",@"精华"];
    [self.view addSubview:self.switchView];
    
    
    __weak typeof(self) weakSelf = self;
    [self.switchView setSelected:^(NSInteger idx) {
        
        weakSelf.switchBySwitchView = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.switchBySwitchView = NO;
            
        });
        
        switch (idx) {
            case 0:
            {
                [weakSelf.allTableView beginRefreshing];
            }
                break;
            case 1:
            {
                [weakSelf.lastTableView beginRefreshing];
                
            }
                break;
            case 2:
            {
                [weakSelf.essenceTableView beginRefreshing];

            }
                break;
            default:
                break;
        }
        
        _index = idx;
        
        [weakSelf.switchScrollView setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0) animated:YES];
        
    }];
    
    
    //
    self.allTableView  = [self tableViewWithFrame:self.switchScrollView.bounds];
    [self.switchScrollView addSubview:self.allTableView];
    self.allTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无帖子"];
    
    //
    self.lastTableView  = [self tableViewWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.allTableView.height)];
    [self.switchScrollView addSubview:self.lastTableView];
    self.lastTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无帖子"];
    
    //
    self.essenceTableView  = [self tableViewWithFrame:CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.allTableView.height)];
    [self.switchScrollView addSubview:self.essenceTableView];
    self.essenceTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无帖子"];
    
    //

}
//--//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        
        if (self.switchBySwitchView) {
            
            
        } else {
        
            NSInteger idx = scrollView.contentOffset.x/scrollView.width;
            self.switchView.selectedIdx = idx;
        }
    
        return;
    }

    //
    if (![scrollView isMemberOfClass:[UIScrollView class]]) {
        
        
        CGFloat y = scrollView.contentOffset.y;
        
        if (  y >= self.falseHeaderView.height ) {
           
            self.switchView.y = 0;
            
        } else {
        
            self.switchView.y = -y + self.falseHeaderView.height;

        }

        self.falseHeaderView.y = -y;
        
        //有一个上滑到临界点，，其它如果超过临界点，无视，，不到临界点，，滑动到临界点
        if (y <= self.falseHeaderView.height) {
            
            if (self.allTableView.contentOffset.y < self.falseHeaderView.height && self.allTableView.contentSize.height > self.allTableView.height) {
                [self.allTableView setContentOffset:CGPointMake(0, y)];
            }
            
            //
            if (self.lastTableView.contentOffset.y < self.falseHeaderView.height && self.lastTableView.contentSize.height > self.lastTableView.height) {
                [self.lastTableView setContentOffset:CGPointMake(0, y)];
            }
            
            //
            if (self.essenceTableView.contentOffset.y < self.falseHeaderView.height && self.essenceTableView.contentSize.height > self.essenceTableView.height) {
                [self.essenceTableView setContentOffset:CGPointMake(0, y)];
            }
            
        }
        
        //w问题：：：：：解决，有一个下滑，到临界点，其它都滑动到临界点
        if(y == 0) {//三个tableview 到0
            
            [self.allTableView setContentOffset:CGPointMake(0, 0)];
            [self.lastTableView setContentOffset:CGPointMake(0, 0)];
            [self.essenceTableView setContentOffset:CGPointMake(0, 0)];
        
        }
        
        //
        
        
    }
    

    
}

- (TLTableView *)tableViewWithFrame:(CGRect)frame  {

    TLTableView *tableView  = [TLTableView tableViewWithframe:frame
                                                    delegate:self
                                                  dataSource:self];
    tableView.rowHeight = 20;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.switchView.height + self.falseHeaderView.height)];
    tableView.tableHeaderView = headerView;
    return tableView;


}

#pragma mark- 用户 帖子搜索
- (void)search {
    
    CSWSearchVC *searchVC = [CSWSearchVC new];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark- 发布帖子
- (void)compose {
    
    TLComposeVC *composeVC = [[TLComposeVC alloc] init];
    
    composeVC.isPlatePush = YES;
    
    CSWSmallPlateModel *model = self.currentPlateDetailModel.splate;
    
    composeVC.plateName = model.name;
    
    TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:composeVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 70;
//
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//    v.backgroundColor = [UIColor yellowColor];
//    return v;
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.allTableView]) {//全部
        
        return self.allArticleLayouItems[indexPath.row].cellHeight;
        
    } else if ([tableView isEqual:self.lastTableView]) { //最新
        
        return self.lastArticleLayouItems[indexPath.row].cellHeight;

        
    } else if ([tableView isEqual:self.essenceTableView]) { //精华
        
        return self.essenceArticleLayouItems[indexPath.row].cellHeight;
        
    } else {
        return 0;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
    
    CSWLayoutItem *layoutItem =  [CSWLayoutItem new];
    
    layoutItem.type = CSWArticleLayoutTypeArticleDetail;
    
    //
    //    detailVC.layoutItem = layoutItem;
    if ([tableView isEqual:self.allTableView]) {//全部
        
        detailVC.articleCode = self.allArticleLayouItems[indexPath.row].article.code;
        
    } else if ([tableView isEqual:self.lastTableView]) { //最新
        
        detailVC.articleCode = self.lastArticleLayouItems[indexPath.row].article.code;
        
        
    } else if ([tableView isEqual:self.essenceTableView]) { //精华
        
        detailVC.articleCode = self.essenceArticleLayouItems[indexPath.row].article.code;
        
    }
    //
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//--//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([tableView isEqual:self.allTableView]) {//全部
        
        return self.allArticleLayouItems.count;
        
    } else if ([tableView isEqual:self.lastTableView]) { //最新
    
        return self.lastArticleLayouItems.count;
        
    } else if ([tableView isEqual:self.essenceTableView]) { //精华
    
        return self.essenceArticleLayouItems.count;
    } else {
        return 0;

    }
    
}


//--//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCellId"];
    if (!cell) {
        
        cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCellId"];
        
    }
    
    NSInteger tag = 0;
    
    if ([tableView isEqual:self.allTableView]) {//全部
        
         cell.layoutItem = self.allArticleLayouItems[indexPath.row];
        
        tag = 2000;
        
    } else if ([tableView isEqual:self.lastTableView]) { //最新
        
        cell.layoutItem = self.lastArticleLayouItems[indexPath.row];

        tag = 3000;
        
    } else if ([tableView isEqual:self.essenceTableView]) { //精华
        
        cell.layoutItem = self.essenceArticleLayouItems[indexPath.row];

        tag = 4000;
        
    } else {
        
    }
    
    cell.toolBar.shareBtn.tag = tag + indexPath.row;
    
    [cell.toolBar.shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;

}

#pragma mark - Events

- (void)clickShare:(UIButton *)sender {
    
    NSInteger index = sender.tag/1000;
    
    CSWLayoutItem *layoutItem = [[CSWLayoutItem alloc] init];
    
    switch (index) {
        case 2:
            
            layoutItem = self.allArticleLayouItems[sender.tag - 2000];
            break;
            
        case 3:
            
            layoutItem = self.lastArticleLayouItems[sender.tag - 3000];
            break;
            
        case 4:
            
            layoutItem = self.essenceArticleLayouItems[sender.tag - 4000];
            break;
            
        default:
            break;
    }
    
    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) shareBlock:^(NSString *title) {
        
        if ([title isEqualToString:@"0"]) {
            
            [TLAlert alertWithSucces:@"分享成功"];
            
        } else {
            
            [TLAlert alertWithError:@"分享失败"];
            
        }
        
    } vc:self];
    
    shareView.shareTitle = layoutItem.article.title;
    shareView.shareDesc = layoutItem.article.content;
    shareView.shareURL = [NSString stringWithFormat:@"%@%@", [AppConfig config].shareBaseUrl, layoutItem.article.code];
    
    NSString *shareImgStr = layoutItem.article.picArr.count > 0 ? layoutItem.article.picArr[0]: @"";
    
    shareView.shareImgStr = shareImgStr;
    
    [self.view addSubview:shareView];
}

@end
