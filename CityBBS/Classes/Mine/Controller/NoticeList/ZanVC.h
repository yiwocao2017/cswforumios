//
//  ZanVC.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZanVC : TLBaseVC

//用户id 或者 用户昵称,优先使用用户ID，如果id不存在，那就根据昵称加载用户
@property (nonatomic, copy) NSString *userId;

@end
