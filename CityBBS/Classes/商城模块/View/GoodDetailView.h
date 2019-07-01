//
//  GoodDetailView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "CircleGuideView.h"
#import "GoodsInfoModel.h"

// 轮播图被点击
typedef void (^CarouselClickBlock) (NSInteger index);

//点击底部按钮
typedef void (^GoodBuyBlock) (NSString *goodCode);

@interface GoodDetailView : UIView

@property (nonatomic, strong) CircleGuideView *circleView;

@property (nonatomic, strong) GoodsInfoModel *goodInfoModel;

@property (nonatomic, strong) WKWebView *webView;

- (instancetype)initWithFrame:(CGRect)frame carousel:(CarouselClickBlock)carouselBlock buyBlock:(GoodBuyBlock)buyBlock;

- (void)updateHeaderImgList:(NSArray*)dataSource;

- (void)refreshWebViewHeight;

@end
