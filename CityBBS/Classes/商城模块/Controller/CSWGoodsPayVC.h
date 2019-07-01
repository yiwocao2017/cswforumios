//
//  CSWGoodsPayVC.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
#import "GoodsInfoModel.h"

@interface CSWGoodsPayVC : TLBaseVC
//订单编号
@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) GoodsInfoModel *model;

@end
