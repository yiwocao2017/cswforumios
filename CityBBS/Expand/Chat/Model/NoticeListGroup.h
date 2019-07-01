//
//  NoticeListGroup.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeListModel.h"

@interface NoticeListGroup : NSObject

@property (nonatomic,copy) NSArray <NoticeListModel *>*items;

@end
