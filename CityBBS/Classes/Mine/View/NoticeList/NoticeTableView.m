//
//  NoticeTableView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NoticeTableView.h"
#import "NoticeListCell.h"

@interface NoticeTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation NoticeTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style group:(id)group {

    if (self = [super initWithFrame:frame style:style]) {
        
        _group = group;
        
        self.dataSource = self;
        self.delegate = self;
        
    }
    
    return self;
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark- datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWNoticeListCellID"];
    
    if (!cell) {
        
        cell = [[NoticeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWNoticeListCellID"];
        
    }
    
    //
    
    if (indexPath.row == 3) {
        
        [cell.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_equalTo(0);
        }];
    }
    cell.noticeListModel = self.group.items[indexPath.row];
    //
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}
@end
