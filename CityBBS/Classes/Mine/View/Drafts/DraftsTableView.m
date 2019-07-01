//
//  DraftsTableView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "DraftsTableView.h"
#import "DraftsTableViewCell.h"
#import "UIView+Responder.h"

@interface DraftsTableView ()<RefreshTableViewDelegate>
//草稿列表
@property (nonatomic, strong) NSArray *draftsListArray;

@end

@implementation DraftsTableView

static NSString *draftsTableViewCell = @"DraftsTableViewCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style repeatPostBlock:(RepeatPostBlock)repeatPostBlock {

    if (self = [super initWithFrame:frame style:style]) {
        
        _repeatPostBlock = [repeatPostBlock copy];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([DraftsTableViewCell class]) bundle:nil] forCellReuseIdentifier:draftsTableViewCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _draftsListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DraftsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:draftsTableViewCell forIndexPath:indexPath];
    
    PoseInfo *poseInfo = _draftsListArray[indexPath.row];
    
    cell.poseInfo = poseInfo;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.repeatBtn.tag = 1000 + indexPath.row;
    
    [cell.repeatBtn addTarget:self action:@selector(repeatPoseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}

#pragma mark 编辑模式

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
//        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *actionArr = @[].mutableCopy;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"你真的要删除这篇草稿？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteArticleWithIndex:indexPath.row];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:cancelAction];
        [alertVC addAction:submitAction];

        
        [self.viewController presentViewController:alertVC animated:YES completion:nil];
    }];
    
    deleteAction.backgroundColor = [UIColor themeColor];
    
    [actionArr addObject:deleteAction];

    return actionArr;
}

- (void)deleteArticleWithIndex:(NSInteger)index {
    
    PoseInfo *postInfo = _draftsListArray[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"610116";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"type"] = @"1";
    http.parameters[@"codeList"] = @[postInfo.code];
    
    [http postWithSuccess:^(id responseObject) {
    
        NSMutableArray *array = _draftsListArray.mutableCopy;
        
        [array removeObjectAtIndex:index];
        
        _draftsListArray = array.copy;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
//        if (_draftsListArray.count == 1) {
//            
//            [self reloadData];
//            
//            
//        } else {
//        
//           
//        }
        
        if (_draftsListArray.count == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self initNoDraftsView];

            });

        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)repeatPoseBtn:(UIButton *)sender {

    if (_repeatPostBlock) {
        
        _repeatPostBlock(sender.tag - 1000);
    }
}

#pragma mark - Data

- (void)setDraftsListModel:(DraftsListModel *)draftsListModel {

    _draftsListModel = draftsListModel;
    
    _draftsListArray = _draftsListModel.list;
    
    [self reloadData];
}

- (void)initNoDraftsView {
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kClearColor;
    [self.viewController.view addSubview:bgView];
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

@end
