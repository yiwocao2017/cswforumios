//
//  CSWDIYVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWDIYVC.h"
#import "CSWDIYOverAllVC.h"
#import "CSWDIYPartVC.h"
#import "CSWCityManager.h"
#import "CSWVideoModel.h"


@interface CSWDIYVC ()

//整体自定义
@property (nonatomic, strong) CSWDIYOverAllVC *overAllVC;

//局部自定义
@property (nonatomic, strong) CSWDIYPartVC *partVC;

@end

@implementation CSWDIYVC

- (CSWDIYOverAllVC *)overAllVC {

    if (!_overAllVC) {
        
        _overAllVC = [[CSWDIYOverAllVC alloc] init];
        
    }
    return _overAllVC;

}


- (CSWDIYPartVC *)partVC {
    
    if (!_partVC) {
        
        _partVC = [[CSWDIYPartVC alloc] init];
        
    }
    return _partVC;
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.title = [CSWCityManager manager].tabBarRoom[2].name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"DIY";
    
    //
    [self initData];
    
    //城市切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange) name:kCityChangeNotification object:nil];
}


- (void)initData {

    //1.判断有一个视频还是很多视频
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"610055";
    http.parameters[@"companyCode"] = [CSWCityManager manager].currentCity.code;
    //1 未上架 2 已上架 3已下架
    http.parameters[@"status"] = @"2";
    
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"20";
    http.parameters[@"orderColumn"] = @"order_no";
    http.parameters[@"orderDir"] = @"asc";
    http.parameters[@"orderColumn"] = @"order_no";
    http.parameters[@"orderDir"] = @"asc";
    
    [http postWithSuccess:^(id responseObject) {
        
        [self.tl_placeholderView removeFromSuperview];
        
        //一个视频
        NSArray <CSWVideoModel *>*arr = [CSWVideoModel tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
        
        if (arr.count > 1) {
            
            [self addChildViewController:self.partVC];
            
            //        self.partVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.view addSubview:self.partVC.view];
            [self.partVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            
        } else if(arr.count == 1) {
            
            self.overAllVC.url = arr[0].url;
            [self addChildViewController:self.overAllVC];
            [self.view addSubview:self.overAllVC.view];
            
            
            self.overAllVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
            
        } else { //无视频
            
            //此处应提醒用户
            [self initNoVideoView];
            
        }
        
        
    } failure:^(NSError *error) {
        
        
        [self tl_placholderViewWithTitle:@"加载失败" opTitle:@"重新加载"];
        [self.view addSubview:self.tl_placeholderView];
        
        
    }];

    
}

- (void)initNoVideoView {

    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kClearColor;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(50);
        
    }];
    
    UILabel *promptLabel = [UILabel labelWithText:@"暂无视频" textColor:kBlackColor textFont:14.0];
    
    promptLabel.textAlignment = NSTextAlignmentCenter;
    
    [bgView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];

}

- (void)tl_placeholderOperation {

    [self initData];
    
}

- (void)cityChange {

    //
    [self.partVC removeFromParentViewController];
    [self.partVC.view removeFromSuperview];
    
    //
    [self.overAllVC removeFromParentViewController];
    [self.overAllVC.view removeFromSuperview];
    
    //
    [self initData];

}

@end
