//
//  CSWTimeLineVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWTimeLineVC.h"
#import "TLNavigationController.h"
#import "TLComposeVC.h"

#import "CSWSwitchView.h"
#import "CSWForumVC.h"
#import "TLUserLoginVC.h"
#import "CSWSearchVC.h"
#import "PostSelectView.h"
#import "CSWPostListVC.h"

@interface CSWTimeLineVC ()<UIScrollViewDelegate>


@property (nonatomic, strong) CSWSwitchView *switchView;

@property (nonatomic, assign) BOOL switchBySwitchView;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) PostSelectView *selectView;

@property (nonatomic, strong) NSArray *itemTitles;

@property (nonatomic, strong) UIScrollView *bgScrollView;

@end

@implementation CSWTimeLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //left-search
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"headline_search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //right-send
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
    
    self.isFirst = YES;
    //顶部有料和论坛的切换
    CGFloat h = 35;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - h, 120, h)];
    headerView.centerX = [UIScreen mainScreen].bounds.size.width/2.0;
    //    headerView.backgroundColor = [UIColor orangeColor];
    
    //背景
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, bgScrollView.height);
    [self.view addSubview:bgScrollView];
    bgScrollView.pagingEnabled = YES;
    bgScrollView.delegate = self;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    
    self.bgScrollView = bgScrollView;
    
    //论坛版块相关
    CSWForumVC *forumVC = [[CSWForumVC alloc] init];
    [self addChildViewController:forumVC];
    forumVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [bgScrollView addSubview:forumVC.view];
    
    __weak typeof(self) weakSelf = self;
    self.switchBySwitchView = NO;
    CSWSwitchView *switchView = [[CSWSwitchView alloc] initWithFrame:CGRectMake(0, 0, headerView.width, 40)];
    [headerView addSubview:switchView];
    self.switchView = switchView;
    
    self.navigationItem.titleView = headerView;
    switchView.selected = ^(NSInteger idx){
        
        weakSelf.switchBySwitchView = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.switchBySwitchView = NO;
            
        });
        [bgScrollView setContentOffset:CGPointMake(idx*bgScrollView.width, 0) animated:YES];
        
        
    };
    
    [self initSelectView];
    
    [self addSubViewController];
    
}



- (void)initSelectView {
    
    _itemTitles = @[@"最新发布", @"置顶贴", @"精华贴"];
    
    _selectView = [[PostSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) itemTitles:_itemTitles];
    
    [self.bgScrollView addSubview:_selectView];
    
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < _itemTitles.count; i++) {
        
        CSWPostListVC *childVC = [[CSWPostListVC alloc] init];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kScreenHeight - 64 -40);
        
        
        childVC.postType = i;
        
        [self addChildViewController:childVC];
        
        [_selectView.scrollView addSubview:childVC.view];
        
        [childVC startLoadData];
        
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.switchBySwitchView) {
        
    } else {
        
        if ([scrollView isMemberOfClass:[UIScrollView class]]) {
            
            self.switchView.selectedIndex  =  scrollView.contentOffset.x/scrollView.width;
            
        }
        
    }
    
}

#pragma mark- 用户 帖子搜索
- (void)search {
    
    CSWSearchVC *searchVC = [CSWSearchVC new];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark- 发布帖子
- (void)compose {
    
    
    if (![TLUser user].userId) {
        
        TLNavigationController *navCtrl = [[TLNavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
        [self presentViewController:navCtrl animated:YES completion:nil];
        return;
    }
    
    
    TLComposeVC *composeVC = [[TLComposeVC alloc] init];
    TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:composeVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

@end
