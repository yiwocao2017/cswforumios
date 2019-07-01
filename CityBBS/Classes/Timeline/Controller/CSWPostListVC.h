//
//  CSWPostListVC.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/5.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, PostType) {

    PostTypeNewest = 0,
    PostTypeTop,
    PostTypeEssence,
};

@interface CSWPostListVC : TLBaseVC

@property (nonatomic, assign) PostType postType;

- (void)startLoadData;

@end
