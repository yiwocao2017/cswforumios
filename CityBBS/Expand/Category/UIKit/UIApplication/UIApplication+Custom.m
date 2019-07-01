//
//  UIApplication+Custom.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/9.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UIApplication+Custom.h"

@implementation UIApplication (Custom)



+ (BOOL)canOpenUrl:(NSString*)urlStr {

    if (!PASS_NULL_TO_NIL(urlStr)) {
        return NO;
    }
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]];
}




@end
