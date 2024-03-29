//
//  UIControl+Block.m
//  BS
//
//  Created by 蔡卓越 on 16/4/6.
//  Copyright © 2016年 崔露凯. All rights reserved.
//
#import <objc/runtime.h>
#import "UIControl+Block.h"

static const void *BKControlHandlersKey = &BKControlHandlersKey;

@interface BKControlWrapper : NSObject <NSCopying>

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic) UIControlEvents controlEvents;
@property (nonatomic, copy) void (^handler)(id sender);

@end

@implementation BKControlWrapper

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
    self = [super init];
    if (!self) return nil;
    
    self.handler = handler;
    self.controlEvents = controlEvents;
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[BKControlWrapper alloc] initWithHandler:self.handler forControlEvents:self.controlEvents];
}

- (void)invoke:(id)sender
{
    self.handler(sender);
}

@end

@implementation UIControl (Block)

- (void)bk_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
    NSParameterAssert(handler);
    
    NSMutableDictionary *events = objc_getAssociatedObject(self, BKControlHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, BKControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvents);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    
    BKControlWrapper *target = [[BKControlWrapper alloc] initWithHandler:handler forControlEvents:controlEvents];
    [handlers addObject:target];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

@end
