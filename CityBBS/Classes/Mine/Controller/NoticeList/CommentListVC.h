//
//  CommentListVC.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, CommentType) {

    CommentTypeSend = 0,
    CommentTypeReceive,
};

@interface CommentListVC : TLBaseVC

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) CommentType commentType;

- (void)startLoadData;

@end
