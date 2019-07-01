//
//  OrderListCollectionView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

typedef void(^OrderBlock)(NSInteger index);

@interface OrderListCollectionView : UICollectionView

@property (nonatomic, copy) OrderBlock orderBlock;

@property (nonatomic, strong) OrderListModel *orderListModel;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout orderBlock:(OrderBlock)orderBlock;

@end
