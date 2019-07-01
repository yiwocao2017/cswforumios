//
//  AppDelegate.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//  https://realm.io/cn/docs/objc/latest/

#import "AppDelegate.h"
#import "AppDelegate+JPush.h"
#import "TLTabBarController.h"
#import "IQKeyboardManager.h"
#import "TLComposeVC.h"
#import "AppConfig.h"
#import "AppDelegate+Chat.h"
#import "SVProgressHUD.h"
#import "TLComposeArticleItem.h"
#import "CSWLoadRootVC.h"
#import "CSWArticleDetailVC.h"
#import "CSWSendCommentVC.h"
#import "ChatManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //2.应用环境
    [AppConfig config].runEnv = RunEnvRelease;
    
    [self configIQKeyboard];
    
    //ProgressHUD
    [SVProgressHUD setMaximumDismissTimeInterval:7];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //配置根控制器
    [self configRootViewController];
    
    //配置极光
    [self jpushInitWithLaunchOption:launchOptions];
    
    //配置友盟
    [self configUM];
    
    //配置环信
    [self chatInit];
    
    //打开通知栏触发
    [self notificationWithApplication:application launchOptions:launchOptions];
    
    return YES;
    
}

- (void)notificationWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotification != nil) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBarPushNotificaiton object:nil userInfo:remoteNotification];
        });
        
        
    }
}

#pragma mark - Config
- (void)configIQKeyboard {
    
    //
    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[TLComposeVC class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[CSWArticleDetailVC class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[CSWSendCommentVC class]];
    
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[CSWArticleDetailVC class]];
}

- (void)configRootViewController {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[CSWLoadRootVC alloc] init];
    
    //取出用户信息
    if([TLUser user].isLogin) {
        
        [[TLUser user] initUserData];
        
        //异步跟新用户信息
        [[TLUser user] updateUserInfo];
        
    };
}

- (void)configUM {
    
    [WXApi registerApp:kWXAppID];
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟AppKey
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAppID appSecret:kWXAppSecret redirectURL:kWXURL];
    
}

#pragma mark- 加载应用主体
- (void)loadRoot {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[TLTabBarController alloc] init];
    
}


- (void)userLoginOut {
    
    [[TLUser user] loginOut];
    [[ChatManager defaultManager] chatLoginOut];
    
}

#pragma mark - JPush

#pragma mark - 远程推送

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [self jpushRegisterDeviceToken:deviceToken];
    
}

//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
//
//{
//    NSLog(@"%@", error);
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //    [TLAlert alertWithMsg:@""];
}
//  iOS 8 .9 后台进入前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self chatDidReceiveRemoteApplication:application notification:userInfo];
    
    [self jpushDidReceiveRemoteApplication:application notification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self chatApplicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self chatApplicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    
    if (!result) {
        
        
        // 其他如支付等SDK的回调
    } else {
        
        [WXApi handleOpenURL:url delegate:self];
        
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
    [WXApi handleOpenURL:url delegate:self];

    if (!result) {
        

        // 其他如支付等SDK的回调
    } else {
    
        [WXApi handleOpenURL:url delegate:self];

    }
    return result;
}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{

//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//
//    [WXApi handleOpenURL:url delegate:self];
//
//    if (!result) {
//
//
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}

#pragma mark - WXApiDelegate
//微信结果
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        //返回结果
        NSNotification *notification = [NSNotification notificationWithName:LOGIN_WX_NOTIFICATION object:resp];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end
