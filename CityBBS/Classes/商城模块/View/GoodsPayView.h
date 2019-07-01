//
//  GoodsPayView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfoModel.h"

typedef void(^GoodsPayBlock)();

@interface GoodsPayView : UIView

@property (nonatomic, copy) GoodsPayBlock payBlock;

@property (nonatomic, strong) GoodsInfoModel *model;

@property (nonatomic, strong) UILabel *balanceLabel;

- (instancetype)initWithFrame:(CGRect)frame payBlock:(GoodsPayBlock)payBlock;
@end
