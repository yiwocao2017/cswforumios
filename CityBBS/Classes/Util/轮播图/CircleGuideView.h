//
//  CircleGuideView.h
//
//
//  Created by 崔露凯 on 16/8/10.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ImageOnClicked) (NSInteger index);

@interface CircleGuideView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray  *imageNames;

@property (nonatomic, assign) NSInteger pageCounter;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  图片点击回调
 */
@property (nonatomic, copy) ImageOnClicked imgClickBlock;


- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray*)imageName;

@end

