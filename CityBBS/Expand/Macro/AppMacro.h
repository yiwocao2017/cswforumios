//
//  AppMacro.h
//  CityBBS
//
//  Created by 蔡卓越 on 17/5/15.
//  Copyright © 2017年 tianlei. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
#pragma mark - ToolsMacros

// 如果数据为NULL，设为nil
#define PASS_NULL_TO_NIL(instance) (([instance isKindOfClass:[NSNull class]]) ? nil : instance)

// 处理nil，为空字符串@""
#define STRING_NIL_NULL(x) if(x == nil || [x isKindOfClass:[NSNull class]]){x = @"";}

//
#define ARRAY_NIL_NULL(x) \
if(x == nil || [x isKindOfClass:[NSNull class] ]) \
{x = @[];}


#define CSWWeakSelf  __weak typeof(self) weakSelf = self;

// 统一处理打印日志
#ifdef DEBUG
#define DLog(format, ...)  NSLog(format, __VA_ARGS__)
#else
#define DLog(...)
#endif

#define ArtDEPRECATED(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#pragma mark - UIMacros
// 界面背景颜色
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//151, 215, 76 RGB(195, 207, 72)
#define kAppCustomMainColor     [UIColor appCustomMainColor]
#define kBackgroundColor        RGB(241, 244, 247)
#define kNavBarBackgroundColor  RGB(241, 241, 241)

#pragma mark - 界面尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kWidth(x) (x)*(kScreenWidth)/375.0
#define kHeight(y) (y)*(kScreenHeight)/667.0

#define Font(F)        [UIFont systemFontOfSize:(F)]
#define boldFont(F)    [UIFont boldSystemFontOfSize:(F)]

#pragma mark - 开发中

//YES  开发中， NO 开发完成
#define kInDevelopment NO

#pragma mark - 轮播图

#define kCarouselHeight (kScreenWidth/5*3)

#pragma mark - HttpMacros

//#define SEAVER_APP_ID @"J4*A9N7&B^A9Y7j6sWv8m6%q_p+z-h="

#define SEAVER_APP_ID @"1"

#define  kHttpSignKey  @"&H2S@b&S(1D%a2l(K8^j9@s7&k&a2*_="

#define kHttpServicePushDomain @"http://supermarket-push.beyondin.com"

#define kHttpServicePort @"80"


//// 正式环境
//#define kHttpServiceDomainProduct  @"http://b2c.beyondin.com/?m=api&a=api"
//
//#define kHttpImageServiceProduct   @"http://b2c.beyondin.com/api/uploadImage/appid/1/submit/submit"
//
//#define kHttpImageServiceSubmitProduct @"http://b2c.beyondin.com"
//
//#define kWebServiceDomainProduct @"http://b2c.beyondin.com"


// 测试服务器

#define kHttpServiceDomainSandbox @"http://mall-api.zrllz.cn/?m=api&a=api"

#define kHttpImageServiceSandbox @"http://b2c.beyondin.com"

#define kHttpImageServiceSubmitSandbox  @"http://b2c.beyondin.com/api/uploadImage/appid/1/submit/submit"

#define kWebServiceDomainSandbox @"http://zrllz.cn"



// web路径





#endif /* AppMacro_h */
