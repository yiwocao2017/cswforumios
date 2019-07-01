//
//  UILabel+Custom.h
//  BS
//
//  Created by 蔡卓越 on 16/4/7.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

/**
 白色Label
 */
+ (UILabel *)labelWithTitle:(NSString *)title;

/**
 黑色Label，带frame
 */
+ (UILabel *)labelWithTitle:(NSString *)title frame:(CGRect)frame;

//调整行间距
- (void)labelWithTextString:(NSString *)textString lineSpace:(CGFloat)lineSpace;

//设置Label的字体
+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor textFont:(CGFloat)textFont;

//同一个string里不同的颜色和字体
- (void)labelWithString:(NSString *)string title:(NSString *)title font:(UIFont *)font color:(UIColor *)color;

@end
