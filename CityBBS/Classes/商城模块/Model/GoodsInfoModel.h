//
//  GoodsInfoModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BaseModel.h"

@class Productspecs;
@interface GoodsInfoModel : BaseModel

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *advPic;

@property (nonatomic, assign) NSInteger originalPrice;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, strong) NSArray<Productspecs *> *productSpecs;

@property (nonatomic, assign) NSInteger price1;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *systemCode;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *updater;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger price3;

@property (nonatomic, copy) NSString *slogan;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, assign) NSInteger boughtCount;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, strong) NSNumber *price2;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *desc;

@end
@interface Productspecs : NSObject

@property (nonatomic, copy) NSString *dvalue;

@property (nonatomic, copy) NSString *dkey;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *productCode;

@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, copy) NSString *companyCode;

@property (nonatomic, copy) NSString *systemCode;

@end

