//
//  TLFunc3Cell.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSWFuncModel;

@interface TLFunc3Cell : UICollectionViewCell

+ (NSString *)reuseId;
@property (nonatomic, strong) CSWFuncModel *funcModel;

@property (nonatomic, strong) UIView *lineView;

@end
