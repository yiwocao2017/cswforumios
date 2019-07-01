//
//  CSWGoodsCell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"
#import "OrderListModel.h"

@interface CSWGoodsCell : UICollectionViewCell

@property (nonatomic, strong) GoodsInfo *goodsInfo;

@property (nonatomic, strong) OrderInfo *orderInfo;

@end
