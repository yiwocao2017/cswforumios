//
//  GoodsCollectionView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"

typedef void(^GoodsBlock)(NSInteger index);

@interface GoodsCollectionView : UICollectionView

@property (nonatomic, copy) GoodsBlock goodsBlock;

@property (nonatomic, strong) GoodsListModel *goodsListModel;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout goodsBlock:(GoodsBlock)goodsBlock;

@end
