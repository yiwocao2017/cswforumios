//
//  TLEmoticonInputView.h
//  CityBBS
//
//  Created by  tianlei on 2017/3/4.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLEmoticon.h"


@interface TLEmoticonInputView : UIView

+ (instancetype)shareView;

@property (nonatomic, copy) void (^editAction)(BOOL isDelete,TLEmoticon *emoticon);

@end


//#pragma mark- 切换View
//@interface TypeChangeView : UIView
//
//@end
