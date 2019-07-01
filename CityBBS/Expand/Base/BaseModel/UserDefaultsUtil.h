//
//  UserDefaultsUtil.h
//  CityBBS
//
//  Created by 蔡卓越 on 17/5/15.
//  Copyright © 2017年 tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Custom.h"
#import "AppMacro.h"

#define kUserDefaultCookie   @"userDefaultCookie"
#define kUserDefaultUserName @"userDefaultUserName"
#define kUserDefaultPassword @"userDefaultPassword"
#define kUserLoginStatus     @"userLoginStatus"
#define kIsSandbox           @"isSandbox"

@interface UserDefaultsUtil : NSObject


#pragma mark - 基本方法
+ (BOOL)isContainObjectForKey:(NSString*)key;

+ (void)setObject:(id)object forKey:(NSString*)key;

+ (id)getObjectForKey:(NSString*)key;

+ (void)removeObjectForKey:(NSString*)key;

#pragma mark - 读写Cookie
+ (void)setUserDefaultCookie:(NSString*)cookie;

+ (NSString*)getUsetDefaultCookie;

#pragma mark - 读写用户名密码
+ (void)setUserDefaultName:(NSString*)userName;
+ (NSString*)getUserDefaultName;

+ (void)setUserDefaultPassword:(NSString*)password;
+ (NSString*)getUserDefaultPassword;

+ (BOOL)isContainUserDefault;

+ (void)setUserLogin;
+ (void)removeUserLogin;

#pragma 判断测试环境
+ (void)setServiceSandbox:(BOOL)isSandbox;
+ (BOOL)getServiceSandbox;


@end
