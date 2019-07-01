//
//  ZHAccountTf.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LeftType) {

    LeftTypeImage = 0,
    LeftTypeTitle,

};

@interface TLAccountTf : UITextField

@property (nonatomic,strong) UIImageView *leftIconView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic,copy) NSString *tl_placeholder;

@property (nonatomic, assign) LeftType leftType;

- (instancetype)initWithFrame:(CGRect)frame leftType:(LeftType)leftType;

@end
