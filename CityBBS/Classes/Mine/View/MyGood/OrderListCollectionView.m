//
//  OrderListCollectionView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderListCollectionView.h"
#import "CSWGoodsCell.h"

@interface OrderListCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation OrderListCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout orderBlock:(OrderBlock)orderBlock {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        _orderBlock = [orderBlock copy];
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor backgroundColor];
        
        [self registerClass:[CSWGoodsCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    }
    
    return self;
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _orderListModel.list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSWGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = kWhiteColor;
    
    
    OrderInfo *orderInfo = _orderListModel.list[indexPath.row];
    
    cell.orderInfo = orderInfo;
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_orderBlock) {
        
        _orderBlock(indexPath.row);
    }
    
}
@end
