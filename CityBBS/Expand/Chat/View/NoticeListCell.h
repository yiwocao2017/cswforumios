//
//  NoticeListCell.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeListModel.h"

@interface NoticeListCell : UITableViewCell

@property (nonatomic, strong) NoticeListModel *noticeListModel;

@property (nonatomic, strong) UIView *lineView;

@end
