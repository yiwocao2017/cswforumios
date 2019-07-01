//
//  GoodDetailView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/16.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "GoodDetailView.h"

#import "UserDefaultsUtil.h"
#import "UIView+Responder.h"

@interface GoodDetailView ()<UITextFieldDelegate, WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) CarouselClickBlock carouselBlock;
//商品图片
@property (nonatomic, copy) UIImageView *imageView;
//商品名称
@property (nonatomic, strong) UILabel *goodNameLabel;
//商品描述
@property (nonatomic, strong) UILabel *goodDescLabel;
//提示
@property (nonatomic, strong) UILabel *promptLabel;
//兑换地址
@property (nonatomic, strong) UILabel *addressLabel;
//价格
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, copy) GoodBuyBlock buyBlock;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat webHeight;

@property (nonatomic, assign) NSInteger secondLoad;

@end

@implementation GoodDetailView

- (instancetype)initWithFrame:(CGRect)frame carousel:(CarouselClickBlock)carouselBlock buyBlock:(GoodBuyBlock)buyBlock {
    
    if (self = [super initWithFrame:frame]) {
        
        _carouselBlock = [carouselBlock copy];
        
        _buyBlock = [buyBlock copy];
        
        [self initWithSubviews];
    }
    return self;
}

#pragma mark - Init

- (void)initWithSubviews {
    
    [self initWithScrollView];
    
    //作品信息
    [self initWithGoodInfo];
    //web内容页
//    [self initWithWebView];
    
}

- (void)initWithScrollView {
    
    _scrollView = [[UIScrollView alloc]init];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - 50);
    
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
//    CGFloat height = _payType == PayTypeCompanyGift ? kScreenHeight: kScreenHeight - 50;
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
//        make.height.mas_equalTo(height);
        make.height.mas_equalTo(kScreenHeight - 64 - 50);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
}

- (void)initWithGoodInfo {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    [_scrollView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(kCarouselHeight);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    _imageView = imageView;
    
    UIView *firstView = [[UIView alloc] init];
    
    firstView.backgroundColor = kWhiteColor;
    
    [_scrollView addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(kCarouselHeight + 10);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(65);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    _goodNameLabel = [UILabel labelWithText:@"" textColor:kBlackColor textFont:14.0];
    
    _goodNameLabel.numberOfLines = 0;
    [firstView addSubview:_goodNameLabel];
    [_goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_lessThanOrEqualTo(40);
        make.top.mas_equalTo(8);
    }];
    
    _goodDescLabel = [UILabel labelWithText:@"" textColor:kBlackColor textFont:13.0];
    
    _goodDescLabel.numberOfLines = 0;
    [firstView addSubview:_goodDescLabel];
    [_goodDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_lessThanOrEqualTo(40);
        make.top.mas_equalTo(_goodNameLabel.mas_bottom).mas_equalTo(10);
        
    }];
    
    UIView *secondView = [[UIView alloc] init];
    
    secondView.backgroundColor = kWhiteColor;
    
    [_scrollView addSubview:secondView];
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(firstView.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(65);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    _promptLabel = [UILabel labelWithText:@"" textColor:[UIColor themeColor] textFont:13.0];
    
    [_promptLabel labelWithString:@"提示：兑换的物品需要您自行提取" title:@"兑换的物品需要您自行提取" font:Font(13.0) color:kLightGreyColor];
    
    _promptLabel.numberOfLines = 0;
    [secondView addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_lessThanOrEqualTo(40);
        make.top.mas_equalTo(8);
        
    }];
    
    _addressLabel = [UILabel labelWithText:@"" textColor:[UIColor themeColor] textFont:13.0];
    
    [secondView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_lessThanOrEqualTo(40);
        make.top.mas_equalTo(_promptLabel.mas_bottom).mas_equalTo(10);
        
    }];
    
    //底部按钮
    [self initWithBottomView];
    
}

- (void)initWithBottomView {
    
    UIView *bottomView = [[UIView alloc] init];
    
    bottomView.backgroundColor = kWhiteColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kScreenWidth);
        make.left.bottom.mas_equalTo(0);
        
    }];
    
    UILabel *priceLabel = [UILabel labelWithText:@"" textColor:kLightGreyColor textFont:14.0];
    
    [bottomView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15.0);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_equalTo(50);
        
    }];
    
    _priceLabel = priceLabel;
    
    UIButton *buyBtn = [UIButton buttonWithTitle:@"立即兑换" titleColor:kWhiteColor backgroundColor:[UIColor themeColor] titleFont:14.0];
    
    buyBtn.layer.cornerRadius = 3;
    buyBtn.clipsToBounds = YES;
    
    [buyBtn addTarget:self action:@selector(clickBuy:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(144);
        
    }];
    
}

- (void)initWithCarouselView:(NSArray *)imgArray {
    
    _circleView = [[CircleGuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCarouselHeight) imageNames:imgArray];
    
    [_circleView.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-10);
        
    }];
    
    [_scrollView addSubview:_circleView];
    
    _circleView.imgClickBlock = _carouselBlock;
    
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
        make.height.mas_equalTo(kCarouselHeight);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
}

- (void)initWithWebView {
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:wkConfig];
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [_scrollView addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_contentView.mas_bottom).mas_equalTo(0);
        
//        NSInteger height = _payType == PayTypeCompanyGift ? kScreenHeight - kCarouselHeight - 65: kScreenHeight - kCarouselHeight - 65 - 50;
        
//        make.height.mas_equalTo(height);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
}

#pragma mark - Setting

- (void)setGoodInfoModel:(GoodsInfoModel *)goodInfoModel {

    _goodInfoModel = goodInfoModel;

    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_goodInfoModel.pic convertImageUrl]] placeholderImage:[UIImage imageNamed:@""]];

//    if (_goodInfoModel.picList.count == 1) {
//
//        
//    }else {
//        
//        NSMutableArray *mutableArray = [NSMutableArray array];
//        
//        for (int i = 0; i < _giftInfoModel.picList.count; i++) {
//            
//            [mutableArray addObject:_giftInfoModel.picList[i]];
//        }
//        
//        //轮播图
//        [self initWithCarouselView:mutableArray.copy];
//    }
    
    
    _goodNameLabel.text = _goodInfoModel.name;
    
    _goodDescLabel.text = _goodInfoModel.slogan;
    
    _addressLabel.text = _goodInfoModel.desc;
    
    NSString *addressStr = _goodInfoModel.desc;
    
    [_addressLabel labelWithString:[NSString stringWithFormat:@"兑换地址：%@", addressStr] title:addressStr font:Font(13) color:kLightGreyColor];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%@赏金", [_goodInfoModel.price2 convertToRealMoney]];
    [_priceLabel labelWithString:[NSString stringWithFormat:@"价格：%@", moneyStr] title:moneyStr font:Font(14) color:[UIColor themeColor]];
    
//    if (!_secondLoad) {
//        
//        NSString *htmlString = [_giftInfoModel.contents stringByReplacingOccurrencesOfString:@"/Uploads/image/article/" withString:@"/Uploads/image/article/"];
//        
//        
//#warning 修改html edit
//        
//        
//        [_webView loadHTMLString:htmlString baseURL:nil];
//        
//        
//    }
}

#pragma mark - Data
//更新图片
- (void)updateHeaderImgList:(NSArray *)dataSource {
    
    dataSource = dataSource ? dataSource :@[];
    
    _circleView.imageNames = dataSource;
}

- (void)refreshWebViewHeight {
    
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(_webHeight);
        
    }];
}

#pragma mark - Events

- (void)clickBuy:(UIButton *)sender {
    
    if (_buyBlock) {
        
        _buyBlock(_goodInfoModel.code);
    }
}

#pragma mark - UITextFiledDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    [(BaseViewController *)self.viewController stopLoadingAni];
    
    _secondLoad = YES;
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        [self changeWebViewHeight:string];
    }];
    
}

- (void)changeWebViewHeight:(NSString *)heightStr {
    
    CGFloat height = [heightStr integerValue];
    
    // 改变webView和scrollView的高度
    
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(height);
        
    }];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kCarouselHeight + 65 + height);
    
    [_webView sizeToFit];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.scrollEnabled = NO;
}

@end
