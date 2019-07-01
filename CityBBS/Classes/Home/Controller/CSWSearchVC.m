//
//  CSWSearchVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWSearchVC.h"
#import "CSWUserDetailVC.h"
#import "CSWFansCell.h"
#import "CSWTimeLineCell.h"
#import "CSWArticleDetailVC.h"
#import "CSWRelationUserModel.h"

@interface CSWSearchVC ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, assign) BOOL isSearchUser;

@property (nonatomic, strong) CSWSearchTf *searchTf;

@property (nonatomic, strong) TLTableView *tableView;

@property (nonatomic, strong) NSMutableArray <CSWLayoutItem *>*timeLineLayoutItemRoom;

@property (nonatomic, copy) NSArray<TLUser *> *users;

@end

@implementation CSWSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    [_searchTf becomeFirstResponder];

}

- (NSMutableArray<CSWLayoutItem *> *)timeLineLayoutItemRoom {
    
    if (!_timeLineLayoutItemRoom) {
        
        _timeLineLayoutItemRoom = [NSMutableArray new];
    }
    
    return _timeLineLayoutItemRoom;
}

- (void)initSubviews {

    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"帖子",@"用户"]];
    segment.width = 160;
    self.navigationItem.titleView = segment;
    segment.selectedSegmentIndex = 0;
    self.isSearchUser = NO;
    //    segment.backgroundColor = [UIColor whiteColor];
    
    //    segment.tintColor = [UIColor themeColor];
    [segment addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventValueChanged];
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.tableView = tableView;
    
    //
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    searchBgView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = searchBgView;
    
    CSWSearchTf *searchTf = [[CSWSearchTf alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30 , 30)];
    [searchBgView addSubview:searchTf];
    searchTf.layer.cornerRadius = searchTf.height/2.0;
    searchTf.layer.masksToBounds = YES;
    searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTf.placeholder = @"请输入搜索内容";
    searchTf.backgroundColor = [UIColor backgroundColor];
    searchTf.delegate = self;
    searchTf.font = Font(15.0);
    searchTf.returnKeyType = UIReturnKeySearch;
    
    _searchTf = searchTf;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lineColor];
    [searchBgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchBgView.mas_left);
        make.width.equalTo(searchBgView.mas_width);
        make.height.mas_equalTo(@(LINE_HEIGHT));
        make.bottom.equalTo(searchBgView.mas_bottom);
    }];
    
}

#pragma mark - Events

- (void)clickSelect:(UISegmentedControl *)segment {

    _isSearchUser = segment.selectedSegmentIndex;
    
    self.tableView.placeHolderView.hidden = YES;
    
    self.searchTf.text = @"";
    
    [self.tableView reloadData_tl];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearchUser) {
        
        CSWUserDetailVC *userDetailVC = [[CSWUserDetailVC alloc] init];
        
//        userDetailVC.type = CSWUserDetailVCTypeOther;
        userDetailVC.userId = self.users[indexPath.row].userId;
        [self.navigationController pushViewController:userDetailVC animated:YES];
        
    } else {
    
        CSWArticleDetailVC *detailVC = [[CSWArticleDetailVC alloc] init];
        
        CSWLayoutItem *layoutItem =  [CSWLayoutItem new];
        
        layoutItem.type = CSWArticleLayoutTypeArticleDetail;
        
        layoutItem.article = self.timeLineLayoutItemRoom[indexPath.row].article;
        
        detailVC.articleCode = layoutItem.article.code;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearchUser) {
        
        return 60;

    }
    
    return self.timeLineLayoutItemRoom[indexPath.row].cellHeight;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearchUser) {
        
        return self.users.count;
    }
    
    return self.timeLineLayoutItemRoom.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearchUser) {
        
        CSWFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWFansCellID"];
        if (!cell) {
            
            cell = [[CSWFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWFansCellID"];
            
        }
        
        CSWRelationUserModel *user = [self getModelWithTLUser:self.users[indexPath.row]];
        
        cell.user = user;
        
        return cell;
    }
    
    //
    CSWTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWTimeLineCellID"];
    if (!cell) {
        
        cell = [[CSWTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWTimeLineCellID"];
        
    }
    
    cell.layoutItem = self.timeLineLayoutItemRoom[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;

    
}

#pragma mark - Data

- (void)requestSearchList {
    
    CSWWeakSelf;
    
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    
    pageDataHelper.tableView = self.tableView;

    if (self.isSearchUser) {
        
        pageDataHelper.code = @"805255";

        pageDataHelper.parameters[@"nickname"] = self.searchTf.text;
        pageDataHelper.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;

        [pageDataHelper modelClass:[TLUser class]];
        
    } else {
    
        pageDataHelper.code = ARTICLE_QUERY;
        pageDataHelper.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
        pageDataHelper.parameters[@"status"] = @"BD";
        pageDataHelper.parameters[@"keyword"] = self.searchTf.text;
        
        [pageDataHelper modelClass:[CSWArticleModel class]];
        [pageDataHelper setDealWithPerModel:^(id model){
            
            CSWLayoutItem *layoutItem = [CSWLayoutItem new];
            layoutItem.type = CSWArticleLayoutTypeDefault;
            layoutItem.article = model;
            return layoutItem;
            
        }];
        
    }
    
    [self.tableView addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            NSString *promptStr = weakSelf.isSearchUser == 0 ? @"没有相关帖子":@"没有相关用户";
            
            weakSelf.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:promptStr];
            
            weakSelf.tableView.placeHolderView.hidden = NO;
            
            if (weakSelf.isSearchUser) {
                
                weakSelf.users = objs;
                
            } else {
                
                weakSelf.timeLineLayoutItemRoom = objs;
                
            }
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (weakSelf.isSearchUser) {
                
                weakSelf.users = objs;
                
            } else {
                
                weakSelf.timeLineLayoutItemRoom = objs;
                
            }
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView beginRefreshing];
    
    [_searchTf resignFirstResponder];
    
}

//转换模型
- (CSWRelationUserModel *)getModelWithTLUser:(TLUser *)user {

    CSWRelationUserModel *model = [[CSWRelationUserModel alloc] init];
    
    model.nickname = user.nickname;
    model.photo = user.userExt.photo;
    
    return model;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField.text.length > 0) {
        
        [self requestSearchList];

    }
    
    return YES;
}

@end


@implementation CSWSearchTf

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    return [self newRect:bounds];
}

//- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
//
//    
//    
//    CGRect newRect = bounds;
////    newRect.origin.x = newRect.origin.x + 1;
//    return newRect;
//
//}


- (CGRect)newRect:(CGRect)oldRect {
    
    CGRect newRect = oldRect;
    newRect.origin.x = newRect.origin.x + 20;
    return newRect;
}

@end


