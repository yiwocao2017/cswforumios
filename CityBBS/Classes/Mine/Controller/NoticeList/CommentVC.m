//
//  CommentVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CommentVC.h"
#import "SelectView.h"
#import "CommentListVC.h"

@interface CommentVC ()

@property (nonatomic, strong) SelectView *selectView;

@property (nonatomic, strong) NSArray *itemTitles;

@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSelectView];

    [self addSubViewController];

}

#pragma mark - Init
- (void)initSelectView {
    
    _itemTitles = @[@"发出的", @"收到的"];
        
    _selectView = [[SelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) itemTitles:_itemTitles];
    
    [self.view addSubview:_selectView];
    
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < _itemTitles.count; i++) {
        
        CommentListVC *childVC = [[CommentListVC alloc] init];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kScreenHeight - 64 -40);

        childVC.userId = self.userId;
        
        childVC.commentType = i;
        
        [self addChildViewController:childVC];
        
        [_selectView.scrollView addSubview:childVC.view];
        
        [childVC startLoadData];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
