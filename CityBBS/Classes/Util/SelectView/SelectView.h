//
//  SelectView.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles;


@end
