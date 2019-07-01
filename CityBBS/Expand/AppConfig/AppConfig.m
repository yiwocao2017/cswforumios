//
//  AppConfig.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppConfig.h"


void TLLog(NSString *format, ...) {
    
    if ([AppConfig config].runEnv != RunEnvRelease) {
        
        va_list argptr;
        va_start(argptr, format);
        NSLogv(format, argptr);
        va_end(argptr);
    }
    
}

@implementation AppConfig

+ (instancetype)config {

    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });

    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {

    _runEnv = runEnv;
    switch (_runEnv) {
            
        case RunEnvRelease: {
        
            self.qiniuDomain = @"http://oofr2abh1.bkt.clouddn.com/";
            self.chatKey = @"1173161124178193#zjsdcsw";
            self.systemCode = @"CD-CCSW000008";
            self.addr = @"http://114.55.179.135:5401";
            self.shareBaseUrl = @"http://csw.wanyiwoo.com/#/post/";
            self.activityUrl = @"http://huo.wanyiwoo.com/";


        }break;
            
        case RunEnvTest: {
            
            self.qiniuDomain = @"http://oigx51fc5.bkt.clouddn.com";
            self.chatKey = @"tianleios#cd-test";
            self.systemCode = @"CD-CCSW000008";
            self.addr = @"http://139.196.32.206:5401";

            self.shareBaseUrl = @"http://csw.yiwocao.com/#/post/";
            self.activityUrl = @"http://test.huo.yiwocao.com/";
            
        }break;
            
            
        case RunEnvDev: {

          self.qiniuDomain = @"http://oigx51fc5.bkt.clouddn.com";
            
//        self.qiniuDomain = @"http://oofr2abh1.bkt.clouddn.com/";

            self.chatKey = @"tianleios#cd-test";
            self.systemCode = @"CD-CCSW000008";
            self.addr = @"http://106.15.103.7:5401";

            self.shareBaseUrl = @"http://csw.yiwocao.com/#/post/";
            self.activityUrl = @"http://huo.yiwocao.com/";

        }break;
   

    }
    
} 

- (NSString *)pushKey {

    return @"a43e424165ed5c6927615fd2";
    
}


- (NSString *)aliMapKey {

    return @"a3bd76e7d3689fccd4604861cc83450e";
}


- (NSString *)wxKey {

    return @"wxe424f029a98d915b";
}

@end
