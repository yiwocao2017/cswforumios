//
//  UIButton+Custom.m
//  BS
//
//  Created by 蔡卓越 on 16/4/12.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor titleFont:(CGFloat)titleFont {

    return [self buttonWithIamgeName:nil selectedImageName:nil Title:title titleColor:titleColor backgroundColor:backgroundColor titleFont:titleFont cornerRadius:0];

}

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor titleFont:(CGFloat)titleFont cornerRadius:(CGFloat)cornerRadius {

    return [self buttonWithIamgeName:nil selectedImageName:nil Title:title titleColor:titleColor backgroundColor:backgroundColor titleFont:titleFont cornerRadius:cornerRadius];
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName {
    
    return [self buttonWithImageName:imageName selectedImageName:nil];
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {

    return [self buttonWithIamgeName:imageName selectedImageName:selectedImageName Title:nil titleColor:nil backgroundColor:nil titleFont:0 cornerRadius:0];
}

/**总参*/
+ (UIButton *)buttonWithIamgeName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName Title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor titleFont:(CGFloat)titleFont cornerRadius:(CGFloat)cornerRadius {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (title) {
        
        button.titleLabel.font = Font(titleFont);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        if (backgroundColor) {
            
            [button setBackgroundColor:backgroundColor];
        }else {
        
            [button setBackgroundColor:[UIColor clearColor]];
        }
        
    }
    
    if (imageName) {
        
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        if (selectedImageName) {
            
            [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
        }
    }
    
    if (cornerRadius) {
        
        button.layer.cornerRadius = cornerRadius;
    }
    
    return button;
}

@end
