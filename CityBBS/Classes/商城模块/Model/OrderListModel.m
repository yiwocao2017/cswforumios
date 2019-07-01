//
//  OrderListModel.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [OrderInfo class]};
}
@end

@implementation OrderInfo

+ (NSDictionary *)objectClassInArray{
    return @{@"productOrderList" : [ProductorderInfo class]};
}

@end

@implementation User

@end


@implementation ProductorderInfo

@end

@implementation Product

@end


