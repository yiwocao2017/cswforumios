//
//  CSWCityManager.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/24.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWCityManager.h"

#import "CSWWebVC.h"
#import "CSWMallVC.h"
#import "CSWPlateDetailVC.h"
#import "ActivityVC.h"
#import "TLUserLoginVC.h"
#import "CSWPlateWebVC.h"

#define CSW_RECOMMEND_CITY @"推荐"
#define CSW_CURRENT_CITY @"当前"


 NSString * const kCityChangeNotification = @"cswCityChangeNotification";

@implementation CSWCityManager
{
    dispatch_group_t _inGroup;

}

+ (instancetype)manager {

    static CSWCityManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CSWCityManager alloc] init];
        manager.cityDict = [NSMutableDictionary dictionary];
        manager.citys = [NSMutableArray array];
        
//        manager.cityDict[CSW_RECOMMEND_CITY] = [NSArray new];
//        manager.cityDict[CSW_CURRENT_CITY] = [NSArray new];

        
    });
    
    return manager;

}

//
- (instancetype)init {

    if (self = [super init]) {
        
        _inGroup = dispatch_group_create();
        
    }
    
    return self;
    
}


//- (NSArray<CSWCity *> *)citys {
//
//    NSArray *allKeys = self.cityDict.allKeys;
//    if (allKeys.count <= 0) {
//        return nil;
//    }
//    [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//    }];
//
//    return nil;
//}

#pragma mark- 获取城市列表
- (void)getCityListSuccess:(void(^)())success failure:(void(^)())failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"806017";
    //1未上架 2已上架 3已下架
    http.parameters[@"status"] = @"2";
    
    [http postWithSuccess:^(id responseObject) {
        
        //1.清楚数组
        [self.citys removeAllObjects];
        //转换对象
        NSDictionary *dict = responseObject[@"data"];
        //找出推荐
        NSMutableArray <CSWCity *> *hotCitys = [NSMutableArray array];
        
        [dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //取出数组
            NSString *initilStr = dict.allKeys[idx];
            NSArray *citys =  dict[initilStr];
            
            NSArray <CSWCity *>*cityModels = [CSWCity tl_objectArrayWithDictionaryArray:citys];
            [self.citys addObjectsFromArray:cityModels];
            
            //找出推荐热门程序
            [cityModels enumerateObjectsUsingBlock:^(CSWCity * _Nonnull city, NSUInteger idx, BOOL * _Nonnull stop) {
                if (city.isHot) {
                    
                    [hotCitys addObject:city];
                }
                
            }];
            
            self.cityDict[initilStr] = cityModels;

            
        }];
        
        //组装推荐
//        self.cityDict[CSW_CURRENT_CITY] = [NSArray new];
//        self.cityDict[CSW_RECOMMEND_CITY] = hotCitys;
//        NSMutableDictionary
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];

}

#pragma mark- 根据站点查询站点详情
- (void)getCityDetailBy:(CSWCity *)city success:(void(^)())success failure:(void(^)())failure {

//    获取菜单列表: 610087
//    获取banner列表: 610107
//    获取11个子系统列表：610097
    
    __block  NSMutableArray *bannerRoom = nil;
    __block  NSArray <CSWFuncModel *> *funcRoom = nil;
    __block  NSArray <CSWTabBarModel *>*tabBarRoom = nil;
    
    __block NSInteger succesCount = 0;
    
    //banner
    
    //location:1    0
    dispatch_group_enter(_inGroup);
    TLNetworking *bannerHttp = [TLNetworking new];
    bannerHttp.code = @"610107";
    bannerHttp.parameters[@"companyCode"] = city.code;
    bannerHttp.parameters[@"location"] = @"1";
    bannerHttp.parameters[@"orderColumn"] = @"order_no";
    bannerHttp.parameters[@"orderDir"] = @"asc";
    
    [bannerHttp postWithSuccess:^(id responseObject) {
        
        dispatch_group_leave(_inGroup);
        succesCount ++;
        bannerRoom = [CSWBannerModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_inGroup);
        if (failure) {
            failure();
        }
        
    }];


    //获取11个子系统
    
    //location：1是8个小模块   0是3个大模块
    dispatch_group_enter(_inGroup);
    TLNetworking *systemHttp = [TLNetworking new];
    systemHttp.code = @"610097";
    systemHttp.parameters[@"companyCode"] = city.code;
    [systemHttp postWithSuccess:^(id responseObject) {
        
        funcRoom = [CSWFuncModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        funcRoom = [self sortedArrayWithFuncRoom:funcRoom];
        
        succesCount ++;
        
        dispatch_group_leave(_inGroup);
        
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_inGroup);
        
        if (failure) {
            failure();
        }

    }];
    
    
    //获取底部菜单
    dispatch_group_enter(_inGroup);
    TLNetworking *http = [TLNetworking new];
    http.code = @"610087";
    http.parameters[@"companyCode"] = city.code;
    [http postWithSuccess:^(id responseObject) {
        
        tabBarRoom = [CSWTabBarModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        //根据orderNo排序
     tabBarRoom = [tabBarRoom sortedArrayUsingComparator:^NSComparisonResult(CSWTabBarModel *obj1, CSWTabBarModel *obj2) {
            
            if ([obj1.orderNo integerValue] > [obj2.orderNo integerValue]) {
                
                return NSOrderedDescending;
                
            } else {
            
                return NSOrderedAscending;
                
            }
            
        }];
        succesCount ++;

        dispatch_group_leave(_inGroup);
    } failure:^(NSError *error) {
        
        dispatch_group_leave(_inGroup);

        if (failure) {
            failure();
        }
        
    }];
    
   dispatch_group_notify(_inGroup, dispatch_get_main_queue(), ^{
       
       if (succesCount == 3) {
       
           self.bannerRoom = bannerRoom;
           self.func3Room = [funcRoom subarrayWithRange:NSMakeRange(0, 3)];
           self.func8Room = [funcRoom subarrayWithRange:NSMakeRange(3, 8)];
           
           self.xiaoMiModel = tabBarRoom[2];
           self.tabBarRoom = @[tabBarRoom[0],tabBarRoom[1],tabBarRoom[3],tabBarRoom[4]];
           
           if (success) {
               success();
           }
           
       }
       
   });

}

//对11个模块进行排序
- (NSArray <CSWFuncModel *>*)sortedArrayWithFuncRoom:(NSArray <CSWFuncModel *>*)funcRoom {

    //区分location
    funcRoom = [funcRoom sortedArrayUsingComparator:^NSComparisonResult(CSWFuncModel *obj1, CSWFuncModel *obj2) {
        
        if ([obj1.location integerValue] > [obj2.location integerValue]) {
            
            return NSOrderedDescending;
            
        } else {
            
            return NSOrderedAscending;
            
        }
        
    }];
    
//    for (CSWFuncModel *obj1 in funcRoom) {
//        
//        NSLog(@"location = %ld, orderNo = %ld", [obj1.location integerValue], [obj1.orderNo integerValue]);
//    }
    
    //对3个大模块排序
    funcRoom = [funcRoom sortedArrayUsingComparator:^NSComparisonResult(CSWFuncModel *obj1, CSWFuncModel *obj2) {
        
        if ([obj1.location integerValue] == 0 && [obj2.location integerValue] == 0 && [obj1.orderNo integerValue] > [obj2.orderNo integerValue]) {
            
            return NSOrderedDescending;
            
        } else {
            
            return NSOrderedAscending;
            
        }
        
    }];
    
//    for (CSWFuncModel *obj1 in funcRoom) {
//        
//        NSLog(@"location = %ld, orderNo = %ld", [obj1.location integerValue], [obj1.orderNo integerValue]);
//    }
    
    //对8个小模块排序
    funcRoom = [funcRoom sortedArrayUsingComparator:^NSComparisonResult(CSWFuncModel *obj1, CSWFuncModel *obj2) {
        
        if ([obj1.location integerValue] == 1 && [obj2.location integerValue] == 1 && [obj1.orderNo integerValue] > [obj2.orderNo integerValue]) {
            
            return NSOrderedDescending;
            
        } else {
            
            return NSOrderedAscending;
            
        }
        
    }];
    
//    for (CSWFuncModel *obj1 in funcRoom) {
//        
//        NSLog(@"location = %ld, orderNo = %ld", [obj1.location integerValue], [obj1.orderNo integerValue]);
//    }
    
    return funcRoom;
}

#pragma mark- 统一处理，跳转
+ (void)jumpWithUrl:(NSString *)url navCtrl:(UINavigationController *)nacCtrl parameters:(id)parameters signin:(void(^)())signinBlock {
    
    if ([url containsString:@"page"]) { //内部页
        
        if ([url containsString:@"page:mall"]) { //商城
            
            CSWMallVC *mallVC = [[CSWMallVC alloc] init];
            [nacCtrl pushViewController:mallVC animated:YES];
            
        } else if ([url containsString:@"page:board"]) { //板块
        
            NSRange range = [url rangeOfString:@"code:"];
            NSString *code = [url substringFromIndex:range.location + range.length];
            
            CSWPlateDetailVC *plateVC = [[CSWPlateDetailVC alloc] init];
            plateVC.plateCode = code;
            [nacCtrl pushViewController:plateVC animated:YES];
        
        } else if ([url containsString:@"page:signin"]) { //签到
        
            if (signinBlock) {
                signinBlock();
            }
            
        } else if ([url containsString:@"page:activity"]) {
        
            if (![TLUser user].userId) {
                
                TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [nacCtrl presentViewController:nav animated:YES completion:nil];
                
                return;
                
            } else {
            
                ActivityVC *activityVC = [[ActivityVC alloc] init];
                
                activityVC.title = @"同城活动";
                NSString *activityUrl = [NSString stringWithFormat:@"%@?comp=%@&tk=%@", [AppConfig config].activityUrl ,[CSWCityManager manager].currentCity.code,[TLUser user].token];
                activityVC.url = activityUrl;
                [nacCtrl pushViewController:activityVC animated:YES];
            }
        }
        
    } else {//外部页
    
        if (![TLUser user].userId) {
            
            TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [nacCtrl presentViewController:nav animated:YES completion:nil];
            
            return;
            
        } else {
            
            CSWPlateWebVC *webVC = [[CSWPlateWebVC alloc] init];
            
            webVC.url = [NSString stringWithFormat:@"%@&tk=%@", url, [TLUser user].token];
            [nacCtrl pushViewController:webVC animated:YES];
            
        }
        
        
    }


}

@end
