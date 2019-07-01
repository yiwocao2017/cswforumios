//
//  ShareModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/2.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BaseModel.h"

@interface ShareModel : BaseModel

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *desc;

@end
