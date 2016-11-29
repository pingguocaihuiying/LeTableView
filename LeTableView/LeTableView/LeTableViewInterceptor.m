//
//  LeTableViewInterceptor.m
//  LeTableView
//
//  Created by joey on 16/11/9.
//  Copyright © 2016年 com.joey. All rights reserved.
//

#import "LeTableViewInterceptor.h"

@implementation LeTableViewInterceptor
#pragma mark - forward & response override
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) return self.middleMan;
    if ([self.dataSource respondsToSelector:aSelector]) return self.dataSource;
    if ([self.delegate respondsToSelector:aSelector]) return self.delegate;

    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) return YES;
    if ([self.dataSource respondsToSelector:aSelector]) return YES;
    if ([self.delegate respondsToSelector:aSelector]) return YES;

    return [super respondsToSelector:aSelector];
}
@end
