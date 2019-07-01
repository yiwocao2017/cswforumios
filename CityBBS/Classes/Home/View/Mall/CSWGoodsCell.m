//
//  CSWGoodsCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWGoodsCell.h"

@interface CSWGoodsCell()

@property (nonatomic, strong) UIImageView *displayImageView;
@property (nonatomic, strong) UILabel *introduceLbl;
@property (nonatomic, strong) UILabel *moneyLabel;  //价格

@end

@implementation CSWGoodsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat w = (SCREEN_WIDTH - 10 - 10*2)/2.0;
        CGFloat imgW = w - 12.5*2;
        
        self.displayImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.displayImageView];
        [self.displayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.mas_equalTo(12.5);
            make.width.height.mas_equalTo(imgW);
            
        }];
        
        //
        self.introduceLbl = [UILabel labelWithText:@"" textColor:kBlackColor textFont:13.0];
        [self.contentView addSubview:self.introduceLbl];
        self.introduceLbl.numberOfLines = 0;
        [self.introduceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_lessThanOrEqualTo(30);
            make.top.mas_equalTo(self.displayImageView.mas_bottom).mas_equalTo(8);
            
        }];
        
        self.moneyLabel = [UILabel labelWithText:@"" textColor:kLightGreyColor textFont:11.0];
        
        [self.contentView addSubview:self.moneyLabel];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_lessThanOrEqualTo(30);
            make.top.mas_equalTo(self.introduceLbl.mas_bottom).mas_equalTo(8);
            
        }];
        
    }
    
    return self;
    
}

- (void)setGoodsInfo:(GoodsInfo *)goodsInfo {

    _goodsInfo = goodsInfo;
    
    _introduceLbl.text = goodsInfo.name;
    
    NSString *moneyStr = [NSString stringWithFormat:@"%@赏金", [goodsInfo.price2 convertToRealMoney]];
    [_moneyLabel labelWithString:[NSString stringWithFormat:@"价格：%@", moneyStr] title:moneyStr font:Font(11) color:[UIColor themeColor]];

    
    [_displayImageView sd_setImageWithURL:[NSURL URLWithString:[goodsInfo.pic convertImageUrl]] placeholderImage:[UIImage imageNamed:@""]];
}

- (void)setOrderInfo:(OrderInfo *)orderInfo {

    _orderInfo = orderInfo;
    
    ProductorderInfo *productorderInfo = _orderInfo.productOrderList[0];
    
    Product *product = productorderInfo.product;
    
    _introduceLbl.text = product.name;
    
    NSString *moneyStr = [NSString stringWithFormat:@"%@赏金", [productorderInfo.price2 convertToRealMoney]];
    [_moneyLabel labelWithString:[NSString stringWithFormat:@"价格：%@", moneyStr] title:moneyStr font:Font(11) color:[UIColor themeColor]];
    
    
    [_displayImageView sd_setImageWithURL:[NSURL URLWithString:[product.advPic convertImageUrl]] placeholderImage:[UIImage imageNamed:@""]];
}


@end
