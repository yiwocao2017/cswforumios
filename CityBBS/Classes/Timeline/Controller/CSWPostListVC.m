//
//  CSWPostListVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWPostListVC.h"
#import "CSWTimeLineCell.h"
#import "CSWLayoutItem.h"
#import "CSWArticleModel.h"
#import "CSWArticleDetailVC.h"
#import "ShareView.h"

@interface CSWPostListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *timeLineTableView;
@property (nonatomic, strong) CSWLayoutItem *layoutItem;
@property (nonatomic, strong) NSMutableArray <CSWLayoutItem *>*timeLineLayoutItemRoom;
@property (nonatomic, strong) TLPageDataHelper *timeLinePageDataHelper;

@end

@implementation CSWPostListVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.timeLineTableView beginRefreshing];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange) name:kCityChangeNotification object:nil];

    [self initTableView];
}

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

- (void)initTableView {
    
    //时间线table
    self.timeLineTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    self.timeLineTableView.delegate = self;
    self.timeLineTableView.dataSource = self;
    [self.view addSubview:self.timeLineTableView];
    self.timeLineTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无帖子"];
    
}

- (void)cityChange {
    
    self.timeLinePageDataHelper
    .parameters[@"companyCode"] =[CSWCityManager manager].currentCity.code;
    [self.timeLineTableView beginRefreshing];
    
}

#pragma mark - Data

- (void)refreshPostList {

    CSWWeakSelf;

    //location:A(置顶)  B(精华) 传空(最新)
    TLPageDataHelper *timeLinePageData = [[TLPageDataHelper alloc] init];
    timeLinePageData.code = ARTICLE_QUERY;
    timeLinePageData.parameters[@"companyCode"] =[CSWCityManager manager].currentCity.code;
    timeLinePageData.parameters[@"status"] = @"BD";
    
    NSString *location = @"";
    
    switch (_postType) {
            
        case 0:
            location = @"";
            break;
            
        case 1:
            location = @"A";
            break;
            
        case 2:
            location = @"B";
            break;
            
        default:
            break;
    }
    
    timeLinePageData.parameters[@"location"] = location;
    
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

- (void)startLoadData {

    [self refreshPostList];
    
    [self.timeLineTableView beginRefreshing];
}

#pragma mark - UITableViewDataSource

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
    
    cell.toolBar.shareBtn.tag = 2000 + indexPath.row;
    
    [cell.toolBar.shareBtn addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    //    cell.layoutItem = self.layoutItem;
    cell.layoutItem = self.timeLineLayoutItemRoom[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - Events

- (void)clickShare:(UIButton *)sender {
    
    CSWLayoutItem *layoutItem = self.timeLineLayoutItemRoom[sender.tag - 2000];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
