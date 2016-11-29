//
//  LeScrollViewInterceptor.m
//  LeTableView
//
//  Created by joey on 16/11/14.
//  Copyright © 2016年 com.joey. All rights reserved.
//

#import "LeScrollViewInterceptor.h"

@implementation LeScrollViewInterceptor
-(BOOL)respondsToSelector:(SEL)aSelector{
    if ([self.middleMan respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

-(id)forwardingTargetForSelector:(SEL)aSelector{
    if ([self.middleMan respondsToSelector:aSelector]) {
        return self.middleMan;
    }
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}
@end
