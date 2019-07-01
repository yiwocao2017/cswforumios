//
//  NoticeInfoModel.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NoticeInfoModel.h"

@implementation NoticeInfoModel

- (CGFloat)contentHeight {
    
    //    - 57 - 20 - 20
    CGSize size = [self.smsContent calculateStringSize:CGSizeMake(SCREEN_WIDTH - 77 - 20, MAXFLOAT) font:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
    
    return size.height + 10;
    
}

@end
