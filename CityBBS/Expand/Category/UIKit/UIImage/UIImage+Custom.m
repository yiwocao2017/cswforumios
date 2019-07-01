//
//  UIImage+Custom.m
//  ArtInteract
//
//  Created by 蔡卓越 on 2016/10/22.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "UIImage+Custom.h"

@implementation UIImage (Custom)

//创建抗锯齿头像
- (UIImage*)antialiasedImage {
    return [self antialiasedImageOfSize:self.size scale:self.scale];
}

//创建抗锯齿头像,并调整大小和缩放比。
- (UIImage*)antialiasedImageOfSize:(CGSize)size scale:(CGFloat)scale {
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(1, 1, size.width-5, size.height-5)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



+ (UIImage*)getHumbnailImage:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
