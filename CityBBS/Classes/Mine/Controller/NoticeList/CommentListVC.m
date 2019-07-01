//
//  CommentListVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CommentListVC.h"
#import "CSWLayoutItem.h"
#import "CSWUserDetailEditVC.h"
#import "CSWArticleDetailVC.h"
#import "TLUserLoginVC.h"
#import "ChatViewController.h"
#import "CommentListModel.h"
//#import "CommentListCell.h"
#import "MessageListCell.h"

@interface CommentListVC ()

@property (nonatomic, strong) UIImageView *navBarImageView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) TLUser *currentUser;

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, copy) NSArray<CSWLayoutItem *> *layoutItems;

@end

@implementation CommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Data

- (void)startLoadData {
    
    
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

- (void)initUI {
    
    if (!self.currentUser) {
        NSLog(@"您还没有获取用户的信息");
        return;
    }
    
    //
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    NSString *promptStr = _commentType == CommentTypeSend ? @"暂无评论的帖子": @"暂无被评论的帖子";
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:promptStr];
    
}

#pragma mark- 获取部分数据
- (void)addGetDataAction {
    
    __weak typeof(self) weakSelf = self;
    
    TLPageDataHelper *timeLinePageData = [[TLPageDataHelper alloc] init];
    
    timeLinePageData.code = _commentType == CommentTypeSend ? @"610138": @"610139";
    
    timeLinePageData.parameters[@"userId"] = self.userId;
    //    timeLinePageData.parameters[@"userId"] = @"U2017051214495065020";
    timeLinePageData.parameters[@"start"] = @"1";
    timeLinePageData.parameters[@"limit"] = @"20";
    
    
    timeLinePageData.tableView = self.tableView;
    [timeLinePageData modelClass:[CommontInfo class]];
    
    //数据转换
    [timeLinePageData setDealWithPerModel:^(id model){
        
        CSWLayoutItem *layoutItem = [CSWLayoutItem new];
        layoutItem.type = CSWArticleLayoutTypeDefault;
        layoutItem.commontInfo = model;
        
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
    
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentListCell"];
    if (!cell) {
        
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentListCell"];
        
    }
    
    //数据对接
    
    CommontInfo *commontInfo = self.layoutItems[indexPath.row].commontInfo;
    
    CSWLayoutItem *layoutItem = self.layoutItems[indexPath.row];
    
    layoutItem.article = [self getModelWithCommontInfo:commontInfo];
    layoutItem.type = CSWArticleLayoutTypeArticleDetail;
    
    cell.layoutItem = layoutItem;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

- (CSWArticleModel *)getModelWithCommontInfo:(CommontInfo *)commontInfo {
    
    CSWArticleModel *model = [[CSWArticleModel alloc] init];
    
    Post *post = commontInfo.post;

    model.photo = _commentType == CommentTypeSend? commontInfo.photo: post.photo;
    model.nickname = commontInfo.nickname;
    model.publishDatetime = commontInfo.commDatetime;
    model.title = post.title;
    model.content = post.content;
    model.publisher = commontInfo.commer;
    model.plateName = commontInfo.content;
    model.code = post.code;
    
    return model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
