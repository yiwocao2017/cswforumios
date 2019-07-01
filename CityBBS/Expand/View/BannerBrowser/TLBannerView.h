//
//  XNBannerView.h
//  MOOM
//
//  Created by 田磊 on 16/4/12.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLBannerModel.h"
@interface TLBannerView : UIView

//- (instancetype)initWithFrame:(CGRect)frame urlString:(NSArray <NSString *>*)urls;

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,assign) BOOL isAuto;

//@property (nonatomic,copy) NSArray *imgUrls;
@property (nonatomic, copy) NSArray<TLBannerModel *> *bannerRooms;


//点击选中
@property (nonatomic,copy) void(^selected) (NSInteger index);

@property (nonatomic,weak)  NSTimer *timer;

//@property (nonatomic, strong) UIPageControl *pageCtrl;

@end

