//
//  PostSelectView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostSelectView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles;

@end
