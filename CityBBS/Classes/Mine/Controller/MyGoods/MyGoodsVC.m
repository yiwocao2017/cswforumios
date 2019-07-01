//
//  MyGoodsVC.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MyGoodsVC.h"
#import "SelectView.h"
#import "OrderListVC.h"

@interface MyGoodsVC ()

@property (nonatomic, strong) SelectView *selectView;

@property (nonatomic, strong) NSArray *itemTitles;

@end

@implementation MyGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSelectView];
    
    [self addSubViewController];
}

#pragma mark - Init
- (void)initSelectView {

    _itemTitles = @[@"已支付", @"已取货"];
    
    _selectView = [[SelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) itemTitles:_itemTitles];
    
    [self.view addSubview:_selectView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < _itemTitles.count; i++) {
        
        OrderListVC *childVC = [[OrderListVC alloc] init];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight - 64);
        
        [self addChildViewController:childVC];
        
        [_selectView.scrollView addSubview:childVC.view];
        
        childVC.orderType = i == 0? OrderTypePaid: OrderTypePickUp;
        
        [childVC requestMallInfo];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
