//
//  ZanVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZanVC.h"
#import "CSWUserDetailEditVC.h"
#import "CSWLayoutItem.h"
#import "CSWArticleDetailVC.h"
#import "TLUserLoginVC.h"
//#import "ZanListCell.h"
#import "MessageListCell.h"

@interface ZanVC ()

@property (nonatomic, strong) UIImageView *navBarImageView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) TLUser *currentUser;

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, copy) NSArray<CSWLayoutItem *> *layoutItems;

@end

@implementation ZanVC

//--//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //1.根据userId 获取用户信息
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"805256";
    http.parameters[@"userId"] = self.userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //
        self.currentUser = [TLUser tl_objectWithDictionary:responseObject[@"data"]];
        [self initUI];
        
        [self addGetDataAction];
        [self.tableView beginRefreshing];
        
        //
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

//--//


//--//
- (void)initUI {
    
    if (!self.currentUser) {
        NSLog(@"您还没有获取用户的信息");
        return;
    }
    
    //
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无被点赞的帖子"];
    
}

#pragma mark- 获取部分数据
- (void)addGetDataAction {
    
    __weak typeof(self) weakSelf = self;
    
    TLPageDataHelper *timeLinePageData = [[TLPageDataHelper alloc] init];
    timeLinePageData.code = @"610141";
    timeLinePageData.parameters[@"start"] = @"1";
    timeLinePageData.parameters[@"limit"] = @"20";
    timeLinePageData.parameters[@"userId"] = self.userId;
//    timeLinePageData.parameters[@"userId"] = @"U2017051214495065020";
    
    timeLinePageData.tableView = self.tableView;
    [timeLinePageData modelClass:[ZanInfo class]];
    
    //数据转换
    [timeLinePageData setDealWithPerModel:^(id model){
        
        CSWLayoutItem *layoutItem = [CSWLayoutItem new];
        layoutItem.type = CSWArticleLayoutTypeDefault;
        layoutItem.zanInfo = model;
        
        return layoutItem;
        
    }];
    
    
    //
    [self.tableView addRefreshAction:^{
        
        [timeLinePageData refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.layoutItems = objs;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [timeLinePageData loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.layoutItems = objs;
            [weakSelf.tableView  reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
}

- (UIButton *)btnWithFrame:(CGRect)frame title:(NSString *)title imgName:(NSString *)imageName {
    
    UIButton *chatBtn = [[UIButton alloc] initWithFrame:frame];
    [chatBtn setTitle:title forState:UIControlStateNormal];
    [chatBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    chatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [chatBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
    chatBtn.titleLabel.font = FONT(13);
    return chatBtn;
    
}

- (void)data {
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //计算
    return self.layoutItems[indexPath.row].cellHeight + 20;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
    
    CSWLayoutItem *layoutItem =  [CSWLayoutItem new];
    
    layoutItem.type = CSWArticleLayoutTypeArticleDetail;
    
    layoutItem.article = self.layoutItems[indexPath.row].article;
    
    detailVC.articleCode = layoutItem.article.code;
    //
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.layoutItems.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZanListCell"];
    if (!cell) {
        
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZanListCell"];
        
    }

    //数据对接
    
    ZanInfo *zanInfo = self.layoutItems[indexPath.row].zanInfo;
    
    CSWLayoutItem *layoutItem = self.layoutItems[indexPath.row];
    
    layoutItem.article = [self getModelWithZanInfo:zanInfo];
    layoutItem.type = CSWArticleLayoutTypeArticleDetail;
    
    cell.layoutItem = layoutItem;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

- (CSWArticleModel *)getModelWithZanInfo:(ZanInfo *)zanInfo {

    CSWArticleModel *model = [[CSWArticleModel alloc] init];
    
    model.photo = zanInfo.photo;
    model.nickname = zanInfo.nickname;
    model.publishDatetime = zanInfo.talkDatetime;
    model.title = zanInfo.postTitle;
    model.content = zanInfo.postContent;
    model.publisher = zanInfo.talker;
    model.plateName = @"赞了你的帖子";
    model.code = zanInfo.postCode;
    
    return model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
