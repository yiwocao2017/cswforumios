//
//  Singleton.m
//  CityBBS
//
//  Created by 蔡卓越 on 17/5/15.
//  Copyright © 2017年 tianlei. All rights reserved.
//

#import "Singleton.h"
#import "UserDefaultsUtil.h"

@implementation Singleton

+ (Singleton *)sharedManager {
    
    static Singleton *g_singleton = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        g_singleton = [[super alloc] init];
    });
    return g_singleton;
}

- (NSString *)phpSesionId {
    
    if (_phpSesionId == nil || [_phpSesionId isEqualToString:@""]) {
        NSString *cookie = [UserDefaultsUtil getUsetDefaultCookie];
        if (cookie) {
            _phpSesionId = cookie;
        }
        else {
            _phpSesionId = @"";
        }
    }
    return _phpSesionId;
}

@end
