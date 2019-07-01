//
//  ZHTimeLineToolBar.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSWLayoutItem;

@interface CSWTimeLineToolBar : UIView

@property (nonatomic, strong) CSWLayoutItem *layoutItem;

@property (nonatomic, strong) UIButton *shareBtn;
//点赞
@property (nonatomic, strong) UIButton *dzBtn;

//评论
@property (nonatomic, strong) UIButton *commentBtn;

@end
