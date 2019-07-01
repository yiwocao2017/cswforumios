//
//  NoticeTableView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLTableView.h"
#import "NoticeListGroup.h"

@interface NoticeTableView : TLTableView

@property (nonatomic, strong) NoticeListGroup *group;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style group:(NoticeListGroup *)group;

@end
