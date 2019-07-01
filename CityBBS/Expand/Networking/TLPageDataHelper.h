//
//  TLPageDataHelper.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/17.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLPageDataHelper : NSObject

@property (nonatomic,assign) NSInteger start;
@property (nonatomic,assign) NSInteger limit;

//网络请求的code
@property (nonatomic,copy) NSString *code;

//设置改值后外界只需要 调用reloadData
@property (nonatomic,weak) TLTableView *tableView;

@property (nonatomic, weak) id tableOrCollectionView;


//除start 和 limit 外的其它请求参数
@property (nonatomic,strong) NSMutableDictionary *parameters;
- (void)modelClass:(Class)className;

//对得到的每个数据模型进行加工
@property (nonatomic, copy) id(^dealWithPerModel)(id model);
//列表
@property (nonatomic, assign) BOOL isList;

- (void)refresh:(void(^)(NSMutableArray *objs,BOOL stillHave))refresh failure:(void(^)(NSError *error))failure;

- (void)loadMore:(void(^)(NSMutableArray *objs,BOOL stillHave))loadMore failure:(void(^)(NSError *error))failure;


@end
