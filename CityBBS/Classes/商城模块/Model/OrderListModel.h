//
//  OrderListModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@class OrderInfo,User,ProductorderInfo,Product;

@interface OrderListModel : TLBaseModel

@property (nonatomic, assign) NSInteger pageNO;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) NSArray<OrderInfo *> *list;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) NSInteger pageSize;

@end

@interface OrderInfo : NSObject

@property (nonatomic, assign) NSInteger amount1;

@property (nonatomic, assign) NSInteger yunfei;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) NSInteger amount2;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, strong) NSArray<ProductorderInfo *> *productOrderList;

@property (nonatomic, copy) NSString *reMobile;

@property (nonatomic, assign) NSInteger amount3;

@property (nonatomic, assign) NSInteger payAmount11;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *payDatetime;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) User *user;

@property (nonatomic, copy) NSString *reAddress;

@property (nonatomic, copy) NSString *applyDatetime;

@property (nonatomic, assign) NSInteger payAmount1;

@property (nonatomic, copy) NSString *receiver;

@property (nonatomic, copy) NSString *applyUser;

@property (nonatomic, assign) NSInteger payAmount2;

@property (nonatomic, assign) NSInteger payAmount3;

@property (nonatomic, assign) NSInteger promptTimes;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *companyCode;

@end

@interface User : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *openId;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *identityFlag;

@property (nonatomic, copy) NSString *photo;

@end

@interface ProductorderInfo : NSObject

@property (nonatomic, assign) NSInteger price1;

@property (nonatomic, assign) NSInteger quantity;

@property (nonatomic, assign) NSNumber *price2;

@property (nonatomic, assign) NSInteger price3;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *productCode;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, strong) Product *product;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, copy) NSString *systemCode;

@end

@interface Product : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *advPic;

@end

