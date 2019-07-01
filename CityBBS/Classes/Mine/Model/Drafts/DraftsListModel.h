//
//  DraftsListModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "BaseModel.h"

@class PoseInfo;
@interface DraftsListModel : BaseModel

@property (nonatomic, assign) NSInteger pageNO;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) NSArray<PoseInfo *> *list;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) NSInteger pageSize;

@end

@interface PoseInfo : NSObject

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *publisher;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) NSInteger sumComment;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *publishDatetime;

@property (nonatomic, copy) NSString *isSC;

@property (nonatomic, assign) NSInteger sumRead;

@property (nonatomic, strong) NSArray *commentList;

@property (nonatomic, copy) NSString *isDZ;

@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, copy) NSString *plateCode;

@property (nonatomic, assign) NSInteger sumReward;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, strong) NSArray *likeList;

@property (nonatomic, assign) NSInteger sumLike;

@property (nonatomic, copy) NSString *isLock;

@property (nonatomic, copy) NSString *plateName;

@property (nonatomic, copy) NSString *content;

@end

