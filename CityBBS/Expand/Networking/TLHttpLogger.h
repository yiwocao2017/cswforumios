//
//  TLHttpLogger.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/15.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLHttpLogger : NSObject

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                        apiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(NSString *)httpMethod;

+ (void)logDebugInfoWithResponse:(NSURLResponse *)response
                         apiName:(NSString *)apiName
                   resposeString:(NSString *)responseString
                         request:(NSURLRequest *)request
                           error:(NSError *)error;

//打印json字符串
+ (void)logJSONStringWithResponseObject:(id)responseObject;

@end
