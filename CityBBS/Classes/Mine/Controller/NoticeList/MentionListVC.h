//
//  MentionListVC.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, MentionType) {
    
    MentionTypePost = 0,
    MentionTypeComment,
};

@interface MentionListVC : TLBaseVC

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) MentionType mentionType;

- (void)startLoadData;

@end
