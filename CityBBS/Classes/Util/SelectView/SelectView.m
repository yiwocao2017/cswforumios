//
//  SelectView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/18.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SelectView.h"
#import "UIView+Responder.h"
#import "CSWMallVC.h"

#define kHeadBarHeight 40

@interface SelectView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *itemTitles;

@property (nonatomic, strong) UIView *headView;

//底部线条
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation SelectView

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

    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadBarHeight)];
    _headView.backgroundColor = kWhiteColor;
    [self addSubview:_headView];
    
    CGFloat w = kScreenWidth/(_itemTitles.count*1.0);
    
    for (int i = 0; i < _itemTitles.count; i++) {
        
        UIButton *btn = [UIButton buttonWithTitle:_itemTitles[i] titleColor:kBlackColor backgroundColor:kClearColor titleFont:14.0];
        
        btn.tag = 1200 + i;
        
        btn.selected = i == 0? YES: NO;
        
        [btn setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_headView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(w*i);
            make.width.mas_equalTo(w);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(kHeadBarHeight);
            
        }];
        
        [_btnArray addObject:btn];
    }
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = [UIColor themeColor];
    
    [_headView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(w);
        make.bottom.mas_equalTo(0);
        
    }];
    
    _lineView = lineView;
}

- (void)initScrollView {

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeadBarHeight, kScreenWidth, kScreenHeight - 64 - kHeadBarHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _itemTitles.count, kScreenHeight - 64 - kHeadBarHeight);
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
    //线条偏移量
    CGFloat x = kScreenWidth/(_itemTitles.count*1.0)*index;
    
    for (UIButton *btn in _btnArray) {
        
        btn.selected = sender.tag == btn.tag ? YES: NO;
    }
    
    //滚动
    [UIView animateWithDuration:0.5 animations:^{
        
        [_lineView setX:x];
        
        [_scrollView setContentOffset:point];

    }];
}

@end
