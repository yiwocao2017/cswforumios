//
//  MentionListModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@class MentionInfo,MentionPost;

@interface MentionListModel : TLBaseModel

@property (nonatomic, assign) NSInteger pageNO;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) NSArray<MentionInfo *> *list;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) NSInteger pageSize;

@end

@interface MentionInfo : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *postCode;

@property (nonatomic, copy) NSString *splateName;

@property (nonatomic, copy) NSString *commer;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *parentCode;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *commDatetime;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, strong) MentionPost *post;

@end

@interface MentionPost : NSObject

@property (nonatomic, copy) NSString *plateCode;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *publishDatetime;

@property (nonatomic, assign) NSInteger sumReward;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *publisher;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, assign) NSInteger sumComment;

@property (nonatomic, assign) NSInteger sumLike;

@property (nonatomic, assign) NSInteger sumRead;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *isLock;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *status;

@end

