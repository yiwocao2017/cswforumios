//
//  OrderListVC.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"
typedef NS_ENUM(NSInteger, OrderType) {
    
    OrderTypePaid = 0,      //已支付
    OrderTypePickUp,    //已取货
};

@interface OrderListVC : TLBaseVC

@property (nonatomic, assign) OrderType orderType;

- (void)requestMallInfo;

@end
