//
//  TabbarViewController.m
//  CityBBS
//
//  Created by 蔡卓越 on 17/5/15.
//  Copyright © 2017年 tianlei. All rights reserved.
//

#import "TabbarViewController.h"

#import "NavigationController.h"

//#import "HomeViewController.h"
//#import "FocusViewController.h"
//#import "TopicViewController.h"
//#import "ToolViewController.h"

#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>

//#import "CustomTabar.h"
//#import "UnreadMessageNumApi.h"

//#import "PublishViewController.h"

@interface TabbarViewController () <UITabBarControllerDelegate>


@property (nonatomic, strong) UIButton *addButton;


@property (nonatomic, strong) UILabel *msgLabel;


@end

@implementation TabbarViewController

- (NavigationController*)createNavWithTitle:(NSString*)title imgNormal:(NSString*)imgNormal imgSelected:(NSString*)imgSelected vcName:(NSString*)vcName {
    
    if (![vcName hasSuffix:@"ViewController"]) {
        vcName = [NSString stringWithFormat:@"%@ViewController", vcName];
    }
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[UIImage imageNamed:imgNormal]
                                                     selectedImage:[UIImage imageNamed:imgSelected]];
    
     tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.image= [tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    // tabBarItem.imageInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    
    
    vc.tabBarItem = tabBarItem;
    
    return nav;
}


- (void)createSubControllers {
    
    // 首页
    NavigationController *homeNav = [self createNavWithTitle:@"首页" imgNormal:@"home_un_selected" imgSelected:@"home_selected" vcName:@"Home"];
    
    // 关注
    NavigationController *focusNav = [self createNavWithTitle:@"关注" imgNormal:@"focus_un_selected" imgSelected:@"focus_selected" vcName:@"Focus"];
    
    // 发布
    NavigationController *addNav = [self createNavWithTitle:@"" imgNormal:@"add_un_selected" imgSelected:@"add_selected" vcName:@"Base"];
    
    // 话题
    NavigationController *topicNav = [self createNavWithTitle:@"话题" imgNormal:@"topic_un_selected" imgSelected:@"topic_selected" vcName:@"Topic"];
    
    // 工具
    NavigationController *toolNav = [self createNavWithTitle:@"工具" imgNormal:@"tool_un_selected" imgSelected:@"tool_selected" vcName:@"Tool"];
    
    self.viewControllers = @[homeNav, focusNav, addNav, topicNav,toolNav];
}


// 消息提示红点
- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        
        CGFloat widthButton = kScreenWidth/self.viewControllers.count;
        
        CGFloat msgX = widthButton*2.5 + 6;
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgX, 10, 6, 6)];
        _msgLabel.layer.cornerRadius = 3;
        _msgLabel.layer.masksToBounds = YES;
        _msgLabel.backgroundColor = [UIColor redColor];
        _msgLabel.hidden = YES;
        
        [self.tabBar addSubview:_msgLabel];
    }
   
    return _msgLabel;
}


- (void)createAddButton {
    
    CGFloat widthButton = kScreenWidth/self.viewControllers.count;
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(2 *widthButton, 0, widthButton, 49);
        [_addButton addTarget:self action:@selector(addArticleOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:_addButton];
        
        UIImageView *addImgIcon = [[UIImageView alloc] initWithFrame:CGRectMake((widthButton -35)/2, (49-35)/2, 35, 35)];
        addImgIcon.image = [UIImage imageNamed:@"add_travel_selected"];
        addImgIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_addButton addSubview:addImgIcon];
        
    }
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置tabbar样式
    [UITabBar appearance].tintColor = kAppCustomMainColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor] , NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    
    
    // 创建子控制器
    [self createSubControllers];
    
 
    [self createAddButton];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    
}


#pragma mark - Private
- (void)removeOriginTabbarButton {

    // 移除原来的按钮
    for (UIView *view in self.tabBar.subviews) {
        
        Class c = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:c]) {
            [view removeFromSuperview];
        
        }
    }

}


#pragma mark - Events
- (void)addArticleOnClick:(UIButton*)button {


    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    // [nav.view addSubview:addVoaygeView];

//    PublishViewController *publishVC = [[PublishViewController alloc] init];
//    NavigationController *pubNav = [[NavigationController alloc] initWithRootViewController:publishVC];
//    
//    
//    [nav presentViewController:pubNav animated:YES completion:nil];
}


#pragma mark - Setter
- (void)setIsHaveMsg:(BOOL)isHaveMsg {

    _msgLabel.hidden = !isHaveMsg;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {

    _currentIndex = currentIndex;

    self.selectedIndex = _currentIndex;
    
   // [CustomTabar shareTabbar].index = currentIndex;
}



@end
