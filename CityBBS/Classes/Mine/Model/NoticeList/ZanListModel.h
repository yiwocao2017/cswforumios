//
//  ZanListModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@class ZanInfo;
@interface ZanListModel : TLBaseModel

@property (nonatomic, assign) NSInteger pageNO;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) NSArray<ZanInfo *> *list;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) NSInteger pageSize;

@end

@interface ZanInfo : NSObject

@property (nonatomic, copy) NSString *postCode;

@property (nonatomic, copy) NSString *talker;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *talkDatetime;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *postTitle;

@property (nonatomic, copy) NSString *postContent;

@property (nonatomic, copy) NSString *photo;

@end

