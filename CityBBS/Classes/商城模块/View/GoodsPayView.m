//
//  GoodsPayView.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "GoodsPayView.h"

@interface GoodsPayView ()

@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation GoodsPayView

- (instancetype)initWithFrame:(CGRect)frame payBlock:(GoodsPayBlock)payBlock {

    if (self = [super initWithFrame:frame]) {
        
        _payBlock = [payBlock copy];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {

    //顶部视图
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 81)];
    
    [self addSubview:topView];
    
    UILabel *moneyTitleLabel = [UILabel labelWithText:@"商品金额" textColor:[UIColor textColor] textFont:14.0];
    
    [topView addSubview:moneyTitleLabel];
    [moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(100);
        
    }];
    
    UILabel *moneyLabel = [UILabel labelWithText:@"" textColor:[UIColor themeColor] textFont:14.0];
    
    [topView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(150);
        
    }];
    
    _moneyLabel = moneyLabel;
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = [UIColor lineColor];
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
        
    }];
    
    UILabel *payWayLabel = [UILabel labelWithText:@"支付方式" textColor:[UIColor textColor] textFont:14.0];
    
    [topView addSubview:payWayLabel];
    [payWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(100);
        
    }];
    
    //中间部分
    UIView *payWayView = [[UIView alloc] init];
    
    payWayView.backgroundColor = kWhiteColor;
    
    [self addSubview:payWayView];
    [payWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(topView.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"money"]];
    
    [payWayView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(27);
        
    }];
    
    UILabel *balanceTitleLabel = [UILabel labelWithText:@"赏金余额支付" textColor:kBlackColor textFont:16.0];
    
    [payWayView addSubview:balanceTitleLabel];
    [balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(imgView.mas_right).mas_equalTo(13);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(120);
        
    }];
    
    UILabel *balanceLabel = [UILabel labelWithText:@"余额：" textColor:[UIColor textColor] textFont:14.0];
    
    [payWayView addSubview:balanceLabel];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(imgView.mas_right).mas_equalTo(13);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(balanceTitleLabel.mas_bottom).mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(200);
        
    }];
    
    _balanceLabel = balanceLabel;
    
    UIImageView *selectImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select"]];
    
    [payWayView addSubview:selectImgView];
    [selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
        
    }];
    
    UIButton *payBtn = [UIButton buttonWithTitle:@"支付" titleColor:kWhiteColor backgroundColor:[UIColor themeColor] titleFont:16.0];
    
    [payBtn addTarget:self action:@selector(clickPay:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(50);
        
    }];
}

#pragma mark - Setting

- (void)setModel:(GoodsInfoModel *)model {

    _model = model;
    
    _moneyLabel.text = [NSString stringWithFormat:@"%@赏金", [_model.price2 convertToRealMoney]];
}

#pragma mark - Events

- (void)clickPay:(UIButton *)sender {

    if (_payBlock) {
        
        _payBlock();
    }
}

@end
