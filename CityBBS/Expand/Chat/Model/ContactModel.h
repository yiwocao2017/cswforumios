//
//  ContactModel.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ContactModel : TLBaseModel<NSCoding>

@property (nonatomic, copy) NSString *conversationId;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *photo;

@end
