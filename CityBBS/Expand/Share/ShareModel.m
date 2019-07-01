//
//  ShareModel.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/2.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ShareModel.h"

@implementation ShareModel

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        return @"description";
    }
    
    return [propertyName mj_underlineFromCamel];
}

@end
