//
//  NoticeInfoModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface NoticeInfoModel : TLBaseModel

@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, copy) NSString *createDatetime;
@property (nonatomic, copy) NSString *fromSystemCode;
@property (nonatomic, copy) NSString *pushType;
@property (nonatomic, copy) NSString *pushedDatetime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *smsContent;
@property (nonatomic, copy) NSString *smsTitle;
@property (nonatomic, copy) NSString *smsType;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *toKind;
@property (nonatomic, copy) NSString *toSystemCode;


@property (nonatomic,assign) CGFloat contentHeight;

@end
