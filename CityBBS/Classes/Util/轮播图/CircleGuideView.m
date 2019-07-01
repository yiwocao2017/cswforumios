//
//  CircleGuideView.m
//  
//
//  Created by 崔露凯 on 16/8/10.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "CircleGuideView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface CircleGuideView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger maxImageCount;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, assign) BOOL isNetwork;

@end

@implementation CircleGuideView

#pragma mark - Initialization

- (void)createSubviews {
    
    _maxImageCount = _imageNames.count;
    
    [self initWithScrollView];
    
    [self initWithPageControl];
    
    [self prepareImageView];
    
}

- (void)initWithScrollView {

    if (_scrollView) {
        
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    _scrollView.contentSize = CGSizeMake(self.width * 3, 0);
    
    _scrollView.delegate = self;
    
}

- (void)initWithPageControl {

    if (_pageControl) {
        
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    
    _pageControl = [[UIPageControl alloc] init];
    
    _pageControl.numberOfPages = _imageNames.count;
    _pageControl.currentPage = 0;
    
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    
    [self addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(-30);
    }];

}

- (void)prepareImageView {
    
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kCarouselHeight)];
    
    left.contentMode = UIViewContentModeScaleAspectFill;
    left.clipsToBounds = YES;
    
    UIImageView *center = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0,kScreenWidth, kCarouselHeight)];
    
    center.contentMode = UIViewContentModeScaleAspectFill;
    left.clipsToBounds = YES;
    
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0,kScreenWidth, kCarouselHeight)];
    
    right.contentMode = UIViewContentModeScaleAspectFill;
    right.clipsToBounds = YES;
    
    center.userInteractionEnabled = YES;
    [center addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgOnClicked:)]];
    
    [_scrollView addSubview:left];
    [_scrollView addSubview:center];
    [_scrollView addSubview:right];

    _leftImageView = left;
    _centerImageView = center;
    _rightImageView = right;
    
    _currentIndex = 0;
    
    [self changeImageLeft:_maxImageCount-1 center:0 right:1];
    
}

- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageName {
    
    if (self = [super initWithFrame:frame]) {
        
        _imageNames = imageName;
        
        [self createSubviews];
        
        [self setUpTimer];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

- (void)imgOnClicked:(UITapGestureRecognizer*)tap {

    if (_imgClickBlock != nil) {
        
        _imgClickBlock(_currentIndex);
    }
}

#pragma mark - Setter
- (void)setImageNames:(NSArray *)imageNames {
    
    _imageNames = imageNames;
    
}

#pragma mark - Events

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self setUpTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self changeImageWithOffset:scrollView.contentOffset.x];
}

- (void)changeImageWithOffset:(CGFloat)offsetX {
    
    if (offsetX >= kScreenWidth * 2) {
        _currentIndex++;
        
        if (_currentIndex == _maxImageCount-1) {
            
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else if (_currentIndex == _maxImageCount) {
            
            _currentIndex = 0;
            [self changeImageLeft:_maxImageCount-1 center:0 right:1];
            
        }else {
            
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _pageControl.currentPage = _currentIndex;
        
    }
    
    if (offsetX <= 0) {
        
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_maxImageCount-1 center:0 right:1];
            
        }else if (_currentIndex == -1) {
            
            _currentIndex = _maxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        
        _pageControl.currentPage = _currentIndex;
    }
    
}

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex {
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[self setImageWithIndex:LeftIndex]] placeholderImage:[UIImage imageNamed:@"carousel_figure_img"]];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[self setImageWithIndex:centerIndex]] placeholderImage:[UIImage imageNamed:@"carousel_figure_img"]];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[self setImageWithIndex:rightIndex]] placeholderImage:[UIImage imageNamed:@"carousel_figure_img"]];
    
    [_scrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
}

- (NSString *)setImageWithIndex:(NSInteger)index {

    NSString *imageStr = _imageNames[index];
    
    return imageStr;
}

- (void)startScorll {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + kScreenWidth, 0) animated:YES];
}

- (void)setUpTimer {
//    if (_AutoScrollDelay < 0.5) return;
    
    _timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(startScorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    
    if (_timer == nil) {
    
        return;
    }
    
    [_timer invalidate];
    
    _timer = nil;
}

@end
