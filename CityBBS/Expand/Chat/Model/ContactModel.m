//
//  ContactModel.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/6/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.conversationId forKey:@"conversationId"];
    
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    
    [aCoder encodeObject:self.photo forKey:@"photo"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super init]) {
        
        self.conversationId = [aDecoder decodeObjectForKey:@"conversationId"];
        
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        
        self.photo = [aDecoder decodeObjectForKey:@"photo"];
        
    }
    return self;
}

@end
