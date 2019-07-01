//
//  DraftsTableView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BaseTableView.h"
#import "DraftsListModel.h"

typedef void(^RepeatPostBlock)(NSInteger index);

@interface DraftsTableView : BaseTableView

@property (nonatomic, copy) RepeatPostBlock repeatPostBlock;

@property (nonatomic, strong) DraftsListModel *draftsListModel;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style repeatPostBlock:(RepeatPostBlock)repeatPostBlock;

@end
