//
//  CSWArticleApi.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/13.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWArticleApi.h"

@implementation CSWArticleApi

+ (void)reportArticleWithArticleCode:(NSString *)code
                            reporter:(NSString *)userId
                          reportNote:(NSString *)reportNote
                             success:(void(^)())success
                             failure:(void(^)())failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"610113";
    http.parameters[@"code"] = code;
    http.parameters[@"reporter"] = userId;
    http.parameters[@"reportNote"] = reportNote;
    http.parameters[@"type"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];


}

+ (void)reportCommentWithCommentCode:(NSString *)code
                            reporter:(NSString *)userId
                          reportNote:(NSString *)reportNote
                             success:(void(^)())success
                             failure:(void(^)())failure {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"610113";
    http.parameters[@"code"] = code;
    http.parameters[@"reporter"] = userId;
    http.parameters[@"reportNote"] = reportNote;
    http.parameters[@"type"] = @"2";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    
    
}


+ (void)cancleCollectionArticleWithCode:(NSString *)code
                                   user:(NSString *)userId
                                success:(void(^)())success
                                failure:(void(^)())failure {

    
    TLNetworking *http = [TLNetworking new];
    http.code = @"610121";
    http.parameters[@"postCode"] = code;
    http.parameters[@"userId"] = userId;
    http.parameters[@"type"] = @"2";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    

}

+ (void)collectionArticleWithCode:(NSString *)code
                            user:(NSString *)userId
                             success:(void(^)())success
                             failure:(void(^)())failure {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"610121";
    http.parameters[@"postCode"] = code;
    http.parameters[@"userId"] = userId;
    http.parameters[@"type"] = @"2";
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"收藏成功"];
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    
}

+ (void)dzArticleWithCode:(NSString *)code
                         user:(NSString *)userId
                          success:(void(^)())success
                          failure:(void(^)())failure {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"610121";
    http.parameters[@"postCode"] = code;
    http.parameters[@"userId"] = userId;
    http.parameters[@"type"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    
    
}

+ (void)cancleDzArticleWithCode:(NSString *)code
                           user: (NSString *)userId
                        success:(void(^)())success
                        failure:(void(^)())failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"610121";
    http.parameters[@"postCode"] = code;
    http.parameters[@"userId"] = userId;
    http.parameters[@"type"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];


}


+ (void)dsArticleWithCode:(NSString *)code
                     user:(NSString *)userId
                    money:(CGFloat)money
                  success:(void(^)())success
                  failure:(void(^)())failure {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"610122";
    http.parameters[@"postCode"] = code;
    http.parameters[@"userId"] = userId;
    http.parameters[@"amount"] = [[NSString stringWithFormat:@"%f",money] convertToSysMoney];
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    
    
}

+ (void)addReadTimesWithArticleCode:(NSString *)articleCode {

    TLNetworking *readNumHttp = [TLNetworking new];
    readNumHttp.code = @"610120";
    readNumHttp.parameters[@"postCode"] = articleCode;
    [readNumHttp postWithSuccess:nil failure:nil];

}


/**
 删除帖子
 */
+ (void)deleteArticleWithCode:(NSString *)code
                         user:(NSString *)userId
                      success:(void(^)())success
                      failure:(void(^)())failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"610116";
    http.parameters[@"codeList"] = @[code];
    http.parameters[@"userId"] = userId;
    http.parameters[@"type"] = @"1";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];
    
}


/**
 删除评论
 */
+ (void)deleteCommentWithCode:(NSString *)code
                         user:(NSString *)userId
                      success:(void(^)())success
                      failure:(void(^)())failure {

    TLNetworking *http = [TLNetworking new];
    http.code = @"610116";
    http.parameters[@"codeList"] = @[code];
    http.parameters[@"userId"] = userId;
    http.parameters[@"type"] = @"2";
    [http postWithSuccess:^(id responseObject) {
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure();
        }
        
    }];

}

@end
