//
//  NoticeListModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeListModel : NSObject

@property (nonatomic,strong) NSString *imgName;

@property (nonatomic,strong) NSString *text;

@property (nonatomic,strong) void(^action)();

@end
