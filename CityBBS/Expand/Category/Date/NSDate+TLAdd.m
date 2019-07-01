//
//  NSDate+TLAdd.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NSDate+TLAdd.h"

@implementation NSDate (TLAdd)

+ (NSDate *)getDateByString:(NSString *)str
{
    NSString *dateStr = str;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date01 = [formatter dateFromString:dateStr];
    return date01;
}

@end
