//
//  ContactsVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/3.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ContactsVC.h"
#import "CSWFansCell.h"
#import "CSWUserDetailVC.h"
#import "CSWRelationUserModel.h"
#import "ChatViewController.h"

@interface ContactsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray<CSWRelationUserModel *> *users;
@property (nonatomic, strong) TLTableView *fansOrFocusTableView;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation ContactsVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.isFirst) {
        [self.fansOrFocusTableView beginRefreshing];
        self.isFirst = NO;
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    
    TLTableView *fansOrFocusTableView = [TLTableView tableViewWithframe:CGRectZero delegate:self dataSource:self];
    self.fansOrFocusTableView = fansOrFocusTableView;
    fansOrFocusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fansOrFocusTableView];
    [fansOrFocusTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    fansOrFocusTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无关注的人"];
    
    TLPageDataHelper *pageDateHelper = [[TLPageDataHelper alloc] init];
    pageDateHelper.code = @"805090";
    pageDateHelper.tableView = fansOrFocusTableView;
    
    pageDateHelper.parameters[@"token"] = [TLUser user].token;
    [pageDateHelper modelClass:[CSWRelationUserModel class]];
    
    //我关注了谁
    pageDateHelper.parameters[@"userId"] = [TLUser user].userId;
    
    __weak typeof(self) weakself = self;
    [fansOrFocusTableView addRefreshAction:^{
        
        [pageDateHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.users = objs;
            [weakself.fansOrFocusTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
    [fansOrFocusTableView addLoadMoreAction:^{
        
        [pageDateHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakself.users = objs;
            [weakself.fansOrFocusTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSWRelationUserModel *user = self.users[indexPath.row];
    
    //
    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:user.userId conversationType:EMConversationTypeChat];
    
    chatVC.title = user.nickname;
    
    chatVC.defaultUserAvatarName = @"个人详情头像";
    
    //发送方头像
    chatVC.oppositeAvatarUrlPath = user.photo ?  [user.photo convertImageUrl] : @"个人详情头像";
    
    //我的头像
    chatVC.mineAvatarUrlPath = [TLUser user].userExt.photo ? [[TLUser user].userExt.photo convertImageUrl] : @"个人详情头像";
    [self.navigationController pushViewController:chatVC animated:YES];
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.users.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSWFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWFansCellID"];
    if (!cell) {
        
        cell = [[CSWFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWFansCellID"];
        
    }
    
    //
    cell.user = self.users[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
