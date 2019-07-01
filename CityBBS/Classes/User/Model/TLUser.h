 //
//  TLUser.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/14.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"
#import "TLUserExt.h"
#import "TLThirdUser.h"
#import "ContactModel.h"

@class TLUserExt;

@interface TLUser : TLBaseModel

+ (instancetype)user;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *ljAmount;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *nickname;

//第三方微信登录
@property (nonatomic, strong) TLThirdUser *thirdUser;
@property (nonatomic, assign) BOOL isWXLogin;

//公司编号
@property (nonatomic, copy) NSString *companyCode;

//0 未设置交易密码 1已设置
@property (nonatomic, copy) NSString *tradepwdFlag;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, strong) NSNumber *totalFansNum;
@property (nonatomic, strong) NSNumber *totalFollowNum;

@property (nonatomic, copy) NSString *updateDatetime;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, strong) TLUserExt *userExt;

//环信联系人列表
@property (nonatomic, strong) NSMutableArray <ContactModel *>*contactsArray;

//实名认证的 --- 临时参数
@property (nonatomic, copy) NSString *tempBizNo;
@property (nonatomic, copy) NSString *tempRealName;
@property (nonatomic, copy) NSString *tempIdNo;


//是否为需要登录，如果已登录，取出用户信息
- (BOOL)isLogin;

//用户已登录状态，从数据库中初始化用户信息
- (void)initUserData;

- (void)loginOut;

- (void)saveToken:(NSString *)token;

//存储用户信息
- (void)saveUserInfo:(NSDictionary *)userInfo;

//设置用户信息
- (void)setUserInfoWithDict:(NSDictionary *)dict;

//异步更新用户信息
- (void)updateUserInfo;

- (NSString *)detailAddress;

//转换等级
- (NSString *)userLevel:(NSString *)levelStr;

@end

FOUNDATION_EXTERN  NSString *const kUserLoginNotification;
FOUNDATION_EXTERN  NSString *const kUserLoginOutNotification;
FOUNDATION_EXTERN  NSString *const kUserInfoChange;

