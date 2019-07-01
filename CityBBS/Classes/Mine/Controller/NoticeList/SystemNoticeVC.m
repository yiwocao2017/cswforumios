//
//  SystemNoticeVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SystemNoticeVC.h"
#import "SystemNoticeCell.h"
#import "TLPageDataHelper.h"
#import "NoticeInfoModel.h"
#import "AppConfig.h"

@interface SystemNoticeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <NoticeInfoModel *> *msgs;

@property (nonatomic,strong) TLTableView *msgTV;

@end

@implementation SystemNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [UIBarButtonItem addLeftItemWithImageName:@"返回" frame:CGRectMake(0, 0, 25, 25) vc:self action:@selector(back)];
    
    [self initTableView];
    
    [self requestNoticeList];
    
}

#pragma mark - Init

- (void)initTableView {

    TLTableView *msgTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                       delegate:self
                                                     dataSource:self];
    msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:msgTableView];
    self.msgTV = msgTableView;
    
    msgTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无消息"];
}

#pragma mark - Data

- (void)requestNoticeList {

    __weak typeof(self) weakSelf = self;
    TLPageDataHelper *pageDataHelper = [[TLPageDataHelper alloc] init];
    pageDataHelper.code = @"804040";
    pageDataHelper.tableView = _msgTV;
    pageDataHelper.parameters[@"token"] = [TLUser user].token;
    pageDataHelper.parameters[@"channelType"] = @"4";
    
    pageDataHelper.parameters[@"pushType"] = @"41";
    pageDataHelper.parameters[@"toKind"] = @"1";
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    pageDataHelper.parameters[@"start"] = @"1";
    pageDataHelper.parameters[@"limit"] = @"10";
    pageDataHelper.parameters[@"status"] = @"1";
    pageDataHelper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    pageDataHelper.parameters[@"userId"] = [TLUser user].userId;
    
    //0 未读 1 已读 2未读被删 3 已读被删
    //    pageDataHelper.parameters[@"status"] = @"0";
    //    pageDataHelper.parameters[@"dateStart"] = @""; //开始时间
    [pageDataHelper modelClass:[NoticeInfoModel class]];
    
    [_msgTV addRefreshAction:^{
        
        [pageDataHelper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.msgs = objs;
            [weakSelf.msgTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
    [_msgTV addLoadMoreAction:^{
        
        [pageDataHelper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.msgs = objs;
            [weakSelf.msgTV reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    }];
    
    [_msgTV beginRefreshing];

}

//#pragma mark - Events
//
//- (void)back {
//
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.msgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *msgCellId = @"msgCellId";
    SystemNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:msgCellId];
    
    if (!cell) {
        cell = [[SystemNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgCellId];
    }
    
    cell.noticeInfoModel = self.msgs[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.msgs[indexPath.row].contentHeight + 20 + 15 + 73;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
