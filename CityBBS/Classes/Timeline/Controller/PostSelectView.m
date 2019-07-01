//
//  PostSelectView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PostSelectView.h"
#import "UIView+Responder.h"
#import "CSWMallVC.h"

#define kHeadBarHeight 20
#define kTopViewHeight 40

@interface PostSelectView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *itemTitles;

@property (nonatomic, strong) UIView *headView;

//底部线条
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation PostSelectView

- (instancetype)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles {
    
    if (self = [super initWithFrame:frame]) {
        
        _itemTitles = itemTitles;
        
        _btnArray = [NSMutableArray array];
        
        [self initTopView];
        
        [self initScrollView];
        
    }
    
    return self;
}


#pragma mark - Init

- (void)initTopView {
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
    _headView.backgroundColor = kWhiteColor;
    [self addSubview:_headView];
    
    CGFloat w = kWidth(80);
    
    for (int i = 0; i < _itemTitles.count; i++) {
        
        UIButton *btn = [UIButton buttonWithTitle:_itemTitles[i] titleColor:kBlackColor backgroundColor:kClearColor titleFont:12.0];
        
        btn.tag = 1200 + i;
        
        btn.selected = i == 0? YES: NO;
        
        btn.layer.cornerRadius = kHeadBarHeight/2.0;
        btn.clipsToBounds = YES;
        btn.layer.borderWidth = 1;
        
        btn.layer.borderColor = i == 0? [UIColor themeColor].CGColor: [UIColor lineColor].CGColor;
        
        [btn setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_headView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(w*i + 15*(i+1));
            make.width.mas_equalTo(w);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(kHeadBarHeight);
            
        }];
        
        [_btnArray addObject:btn];
    }

}

- (void)initScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopViewHeight, kScreenWidth, kScreenHeight - 64 - kTopViewHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _itemTitles.count, kScreenHeight - 64 - kTopViewHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = NO;
    [self insertSubview:_scrollView belowSubview:_headView];
    
    _scrollView.contentOffset = CGPointMake(kScreenWidth*0, 0);
    [self addSubview:_scrollView];
}

#pragma mark - Events

- (void)clickBtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    NSInteger index = sender.tag - 1200;
    
    CGPoint point = CGPointMake(index*kScreenWidth, _scrollView.contentOffset.y);
    
    for (UIButton *btn in _btnArray) {
        
        btn.selected = sender.tag == btn.tag ? YES: NO;
        
        btn.layer.borderColor = sender.tag == btn.tag? [UIColor themeColor].CGColor: [UIColor lineColor].CGColor;

    }
    
    //滚动
    [UIView animateWithDuration:0.5 animations:^{
        
        [_scrollView setContentOffset:point];
        
    }];
}

@end
