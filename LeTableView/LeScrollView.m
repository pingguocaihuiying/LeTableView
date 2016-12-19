//
//  LeScrollView.m
//  LeTableView
//
//  Created by joey on 16/11/14.
//  Copyright © 2016年 com.joey. All rights reserved.
//
#define ButtonWidth ([UIScreen mainScreen].bounds.size.width/5)
#define middleX     (self.contentOffset.x + self.bounds.size.width/2)

#import "LeScrollView.h"
#import "LeScrollViewInterceptor.h"
@interface LeScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) LeScrollViewInterceptor *interceptor;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIView *indicatorView;
@end
@implementation LeScrollView{
    CGFloat lastOffsetX;
    NSString *curTitle;
}
@synthesize titleArr;
- (id)initWithFrame:(CGRect)frame withDataArr:(NSArray *)arr{
    self = [super initWithFrame:frame];
    if (self) {
        titleArr = arr;
        self.contentSize = CGSizeMake(ButtonWidth*titleArr.count*3, 0);
        for (int i=0; i<titleArr.count*3; i++) {
            int tagIndex = i%titleArr.count;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake( ButtonWidth*i,0, ButtonWidth, self.bounds.size.height)];
            [btn setTitle:titleArr[tagIndex] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            self.showsVerticalScrollIndicator = NO;
            self.showsHorizontalScrollIndicator = NO;
            [self setContentOffset:CGPointMake(self.contentSize.width/3,0)];
            [self setBackgroundColor:[UIColor blackColor]];
            
        }
    }
    return self;
}
- (void)layoutSubviews{
    CGPoint offset = self.contentOffset;
    for (UIButton * button in self.subviews) {
        if (button.center.x > (offset.x - ButtonWidth/2) && button.center.x < (offset.x + self.bounds.size.width + ButtonWidth/2)) {
            CGFloat space = ABS(middleX - button.center.x);
            CGFloat scale = 1.2 - space / self.frame.size.width;
            CGFloat alpha = space/(self.bounds.size.width/2) * 0.5;
            [button setTransform:CGAffineTransformMakeScale(scale, scale)];
            [button setAlpha:1 - alpha];
            if (space < ButtonWidth/2) {
                [button addSubview:self.indicatorView];
                [self.indicatorView setAlpha:1 - space/ButtonWidth];
                CGSize size = [button.titleLabel.text boundingRectWithSize:CGSizeMake(ButtonWidth, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil].size;
                size.height = self.indicatorView.frame.size.height;
                CGPoint origin = self.indicatorView.frame.origin;
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.indicatorView.frame = CGRectMake(ButtonWidth/2 - size.width/2, origin.y, size.width, 2);
                } completion:nil];
                curTitle = button.titleLabel.text;
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }else{
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }else{
            [button.titleLabel setAlpha:1];
            [button.titleLabel setTransform:CGAffineTransformMakeScale(1, 1)];
        }
    }
}
- (UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(ButtonWidth/2 - 10, self.bounds.size.height-7, 20, 2)];
        [_indicatorView setBackgroundColor:[UIColor blueColor]];
    }
    return _indicatorView;
}
- (LeScrollViewInterceptor*)interceptor{
    if (!_interceptor) {
        _interceptor = [[LeScrollViewInterceptor alloc]init];
        _interceptor.middleMan = self;
    }
    return _interceptor;
}
#pragma mark Deletgate Override
- (void)setDelegate:(id<UIScrollViewDelegate>)delegate{
    self.interceptor.delegate = delegate;
    [super setDelegate:(id<UIScrollViewDelegate>)self.interceptor];
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = self.contentOffset;
    if (offset.x <= 0.0) {
        offset.x = self.contentSize.width/3.0;
    }else if (offset.x >= (self.contentSize.width - self.bounds.size.width)){
        offset.x = self.contentSize.width/3.0 - self.bounds.size.width;
    }
    [self setContentOffset:offset];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastOffsetX = self.contentOffset.x;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = self.contentOffset;
    if (offset.x > lastOffsetX) {
        
        offset.x = (int)(offset.x/ButtonWidth + 1) * ButtonWidth;
    }else{
        
        offset.x = (int)(offset.x/ButtonWidth) * ButtonWidth;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setContentOffset:offset animated:YES];
    });
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self.changeDelegate changeData:curTitle];
    
}
#pragma 切换数据
- (void)changeType:(UIButton *)sender{
    CGPoint offset = self.contentOffset;
    offset.x += (sender.center.x - offset.x - self.bounds.size.width/2);
    [self setContentOffset:offset animated:YES];
}

@end
