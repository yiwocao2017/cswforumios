//
//  MentionListVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MentionListVC.h"
#import "TLNavigationController.h"
#import "CSWTimeLineCell.h"
#import "CSWLayoutItem.h"
#import "CSWArticleDetailVC.h"
#import "CSWSwitchView.h"
#import "CSWForumVC.h"
#import "CSWArticleModel.h"
#import "TLUserLoginVC.h"
#import "MessageListCell.h"
#import "MentionListModel.h"

@interface MentionListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLTableView *timeLineTableView;
@property (nonatomic, strong) CSWLayoutItem *layoutItem;

@property (nonatomic, strong) NSMutableArray <CSWLayoutItem *>*layoutItems;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) TLPageDataHelper *timeLinePageDataHelper;

@end

@implementation MentionListVC

- (CSWLayoutItem *)layoutItem {
    
    if (!_layoutItem) {
        
        _layoutItem = [[CSWLayoutItem alloc] init];
        _layoutItem.article = [CSWArticleModel new];
    }
    return _layoutItem;
    
}

- (NSMutableArray<CSWLayoutItem *> *)layoutItems {
    
    if (!_layoutItems) {
        
        _layoutItems = [NSMutableArray new];
    }
    
    return _layoutItems;
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
    self.timeLineTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) delegate:self dataSource:self];
    self.timeLineTableView.delegate = self;
    self.timeLineTableView.dataSource = self;
    [self.view addSubview:self.timeLineTableView];
    
    NSString *promptStr = _mentionType == MentionTypePost ? @"暂无提到我的帖子":@"暂无提到我的评论";
    self.timeLineTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:promptStr];
    
    [self startLoadData];
    
}

#pragma mark - Data
- (void)startLoadData {
    
    __weak typeof(self) weakSelf = self;
    
#pragma mark- 时间线刷新时间
    TLPageDataHelper *timeLinePageData = [[TLPageDataHelper alloc] init];
    timeLinePageData.code = _mentionType == MentionTypePost ? @"610144": @"610143";
    timeLinePageData.parameters[@"userId"] = [TLUser user].userId;
//    timeLinePageData.parameters[@"userId"] = @"U2017051214495065020";
    timeLinePageData.parameters[@"start"] = @"1";
    timeLinePageData.parameters[@"limit"] = @"20";
    timeLinePageData.tableView = self.timeLineTableView;
    
    if (_mentionType == MentionTypePost) {
        
        [timeLinePageData modelClass:[CSWArticleModel class]];
        
    } else if (_mentionType == MentionTypeComment) {
    
        [timeLinePageData modelClass:[MentionInfo class]];

    }
    
    self.timeLinePageDataHelper = timeLinePageData;
    
    //数据转换
    [timeLinePageData setDealWithPerModel:^(id model){
        
        CSWLayoutItem *layoutItem = [CSWLayoutItem new];
        layoutItem.type = CSWArticleLayoutTypeDefault;
        
        if (_mentionType == MentionTypePost) {
            
            layoutItem.article = model;
            
        } else if (_mentionType == MentionTypeComment) {
            
            layoutItem.mentionInfo = model;
            
        }
        
        return layoutItem;
        
    }];
    
    
    //
    [self.timeLineTableView addRefreshAction:^{
        
        [timeLinePageData refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.layoutItems = objs;
            [weakSelf.timeLineTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.timeLineTableView addLoadMoreAction:^{
        
        [timeLinePageData loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.layoutItems = objs;
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
    return self.layoutItems[indexPath.row].cellHeight + 20;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
    
    CSWLayoutItem *layoutItem =  [CSWLayoutItem new];
    
    layoutItem.type = CSWArticleLayoutTypeArticleDetail;
    
    layoutItem.article = self.layoutItems[indexPath.row].article;
    //
    detailVC.articleCode = layoutItem.article.code;
    //
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.layoutItems.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MentionListCell"];
    if (!cell) {
        
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MentionListCell"];
        
    }
    
    CSWLayoutItem *layoutItem = self.layoutItems[indexPath.row];

    switch (_mentionType) {
        case MentionTypePost:
        {
            
        }
            break;
        
        case MentionTypeComment:
        {

            MentionInfo *mentionInfo = layoutItem.mentionInfo;
            
            layoutItem.article = [self getModelWithMentionInfo:mentionInfo];
            
        }
            break;
            
        default:
            break;
    }
    
    layoutItem.type = _mentionType == MentionTypePost ? CSWArticleLayoutTypeDefault: CSWArticleLayoutTypeArticleDetail;
    cell.layoutItem = layoutItem;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

- (CSWArticleModel *)getModelWithMentionInfo:(MentionInfo *)mentionInfo {
    
    CSWArticleModel *model = [[CSWArticleModel alloc] init];
    
    MentionPost *post = mentionInfo.post;
    
    model.photo = mentionInfo.photo;
    model.nickname = mentionInfo.nickname;
    model.publishDatetime = mentionInfo.commDatetime;
    model.title = post.title;
    model.content = post.content;
    model.publisher = mentionInfo.commer;
    model.plateName = mentionInfo.content;
    model.code = post.code;
    
    return model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
