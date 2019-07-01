//
//  TabbarViewController.h
//  CityBBS
//
//  Created by 蔡卓越 on 17/5/15.
//  Copyright © 2017年 tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarViewController : UITabBarController


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isHaveMsg;


// 移除tabbar上原声的按钮, 一旦tabbar上按钮布局方式改变，按钮就会创建
- (void)removeOriginTabbarButton;


@end
