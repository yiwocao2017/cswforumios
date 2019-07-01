//
//  GoodsCollectionView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "GoodsCollectionView.h"
#import "CSWGoodsCell.h"

@interface GoodsCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation GoodsCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout goodsBlock:(GoodsBlock)goodsBlock {

    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        _goodsBlock = [goodsBlock copy];
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor backgroundColor];

        [self registerClass:[CSWGoodsCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    }
    
    return self;
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _goodsListModel.list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSWGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = kWhiteColor;
    
    GoodsInfo *goodsInfo = _goodsListModel.list[indexPath.row];
    
    cell.goodsInfo = goodsInfo;
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_goodsBlock) {
        
        _goodsBlock(indexPath.row);
    }
    
}

@end
