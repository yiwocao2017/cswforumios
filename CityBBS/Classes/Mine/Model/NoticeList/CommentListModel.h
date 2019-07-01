//
//  CommentListModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@class CommontInfo,Post,ParentComment;

@interface CommentListModel : TLBaseModel

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong) NSArray<CommontInfo *> *list;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pageNO;

@property (nonatomic, assign) NSInteger start;

@end

@interface CommontInfo : NSObject

@property (nonatomic, copy) NSString *commer;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) Post *post;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *commDatetime;

@property (nonatomic, strong) ParentComment *parentComment;

@property (nonatomic, copy) NSString *parentCode;

@property (nonatomic, copy) NSString *photo;

@end

@interface Post : NSObject

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *plateCode;

@property (nonatomic, assign) NSInteger totalReadTimes;

@property (nonatomic, copy) NSString *publishDatetime;

@property (nonatomic, copy) NSString *approveNote;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *publisher;

@property (nonatomic, copy) NSString *approver;

@property (nonatomic, copy) NSString *approveDatetime;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *content;

@end

@interface ParentComment : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *commDatetime;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *parentCode;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *commer;

@end

