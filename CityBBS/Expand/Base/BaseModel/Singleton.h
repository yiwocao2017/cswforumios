//
//  Singleton.h
//  CityBBS
//
//  Created by 蔡卓越 on 17/5/15.
//  Copyright © 2017年 tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Singleton : NSObject

@property (nonatomic, strong) NSString *httpServiceDomain;  // 服务器地址

@property (nonatomic, strong) NSString *httpImageServiceDomain;  // 图片服务器地址
@property (nonatomic, strong) NSString *httpImageServiceSubmitDomain;

@property (nonatomic, strong) NSString *webServiceDomain;  // web服务器地址


@property (nonatomic, strong) NSString *phpSesionId;  //服务器返回的会话ID

@property (nonatomic, strong) NSString *userId;  //用户id

@property (nonatomic, strong) NSString *userName;  //用户手机号

@property (nonatomic, strong) NSString *userPassward;  //用户密码


@property (nonatomic, copy) NSString *registrationID; //极光推送的jpush_reg_id

@property (nonatomic, assign) NSInteger badge; //角标


/** 是否显示登录界面*/
@property (nonatomic , assign) BOOL isShowLoginContrller;

/** 是否刷新首页界面*/
@property (nonatomic , assign) BOOL isReloadHomeContrller;


+ (Singleton *)sharedManager;


@end
