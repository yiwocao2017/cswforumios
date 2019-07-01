//
//  BaseViewController.h
//  CityBBS
//
//  Created by 蔡卓越 on 17/5/15.
//  Copyright © 2017年 tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *titleStr;

- (void)showIndicatorOnWindow;

- (void)showIndicatorOnWindowWithMessage:(NSString *)message;

- (void)showTextOnly:(NSString *)text;

- (void)showErrorMsg:(NSString*)text;

- (void)hideIndicatorOnWindow;

- (void)showReLoginAlert;

- (void)showReLoginVC;

- (BOOL)isLogin;

- (void)dismissReLoginVC;


@end
