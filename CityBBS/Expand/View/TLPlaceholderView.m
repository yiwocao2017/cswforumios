//
//  TLPlaceholderView.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/21.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLPlaceholderView.h"

@implementation TLPlaceholderView

+ (instancetype)placeholderViewWithText:(NSString *)text {

//    TLPlaceholderView *_placholderView = [[TLPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//    
//    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 10, _placholderView.width, 60) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHexString:@"#484848"]];
//            [_placholderView addSubview:lbl];
//   lbl.numberOfLines = 0;
//   lbl.text = text;
//   return _placholderView;
    
    return [self placeholderViewWithText:text topMargin:0];
    
}

+ (instancetype)placeholderViewWithText:(NSString *)text topMargin:(CGFloat)margin {
    
    TLPlaceholderView *_placholderView = [[TLPlaceholderView alloc] initWithFrame:CGRectMake(0, margin, SCREEN_WIDTH, 100)];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentCenter
                           backgroundColor:[UIColor clearColor]
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor colorWithHexString:@"#484848"]];
    [_placholderView addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_placholderView);
        make.top.equalTo(_placholderView.mas_top).offset(20);
    }];
    lbl.numberOfLines = 0;
    lbl.text = text;
    return _placholderView;
    
}
@end
