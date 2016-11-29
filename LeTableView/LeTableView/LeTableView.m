//
//  LeTableView.m
//  LeTableView
//
//  Created by joey on 16/11/9.
//  Copyright © 2016年 com.joey. All rights reserved.
//
#define SW [[UIScreen mainScreen]bounds].size.width
#define SH [[UIScreen mainScreen]bounds].size.height
#define MiddleY (self.contentSize.height/3+self.bounds.size.height/2)

#import "LeTableView.h"
#import "LeTableViewInterceptor.h"
#import "CustomCell.h"
@interface LeTableView()<UITableViewDelegate,
                         UITableViewDataSource>
{
    CGFloat lastOffsetY;
    CGPoint lastPoint;
}


@property (nonatomic, strong) LeTableViewInterceptor *dataSourceInterceptor;
@property (nonatomic, assign) NSInteger actualRows;
@property (nonatomic, assign) BOOL isLoaded;


@end

@implementation LeTableView

#pragma mark - LayoutSubviews Override
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
    }
    return self;
}
- (void)layoutSubviews {
    CGPoint offset = self.contentOffset;
    CGFloat middleY = offset.y + self.bounds.size.height/2;
    for (CustomCell *cell in [self visibleCells]) {
        cell.indictorImage.hidden = YES;
        CGFloat space = ABS(cell.center.y - middleY);
        CGFloat scale = 1.2 - space / self.frame.size.height;
        CGFloat alpha = ABS(middleY - cell.center.y);
        if (alpha < self.rowHeight) {
            [cell.backView setAlpha:1 - alpha/self.rowHeight];
            if (alpha < self.rowHeight/2) {
                cell.indictorImage.hidden = NO;
                cell.backView.alpha = 1;
            }
        }else{
            [cell.backView setAlpha:0];
        }
        [cell.scaleView setTransform:CGAffineTransformMakeScale(scale, scale)];
    }

    [self resetContentOffsetIfNeeded];
    [super layoutSubviews];
}
- (void)resetContentOffsetIfNeeded {
    CGPoint contentOffset  = self.contentOffset;
    //滚动到顶部时
    if (contentOffset.y <= 0.0) {
        contentOffset.y = self.contentSize.height / 3.0;
    }
    //滚动到底部时
    else if (contentOffset.y >= (self.contentSize.height - self.bounds.size.height)) {
        contentOffset.y = self.contentSize.height / 3.0 - self.bounds.size.height;
    }
    [self setContentOffset: contentOffset];
}

#pragma mark - DataSource Delegate Setter/Getter Override
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.dataSourceInterceptor.dataSource = dataSource;
    [super setDataSource:(id<UITableViewDataSource>)self.dataSourceInterceptor];
}
- (void)setDelegate:(id<UITableViewDelegate>)delegate{
    self.dataSourceInterceptor.delegate = delegate;
    [super setDelegate:(id<UITableViewDelegate>)self.dataSourceInterceptor];
}
- (LeTableViewInterceptor *)dataSourceInterceptor {
    if (!_dataSourceInterceptor) {
        _dataSourceInterceptor = [[LeTableViewInterceptor alloc]init];
        _dataSourceInterceptor.middleMan = self;
    }
    return _dataSourceInterceptor;
}


#pragma mark - Delegate Method Override
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    self.actualRows = [self.dataSourceInterceptor.dataSource tableView:tableView numberOfRowsInSection:section];
    return self.actualRows * 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath * actualIndexPath = [NSIndexPath indexPathForRow:indexPath.row % self.actualRows inSection:indexPath.section];
    return [self.dataSourceInterceptor.dataSource tableView:tableView cellForRowAtIndexPath:actualIndexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isLoaded) {
        CustomCell *Ccell = (CustomCell *)cell;
        if (Ccell.center.y == MiddleY) {
            [self insertSubview:Ccell atIndex:self.subviews.count-1];
        }else if (Ccell.center.y == (self.contentSize.height/3 + self.rowHeight/2)){
            [self insertSubview:Ccell atIndex:self.subviews.count-2];
        }
        if (Ccell.center.y != MiddleY) {
            // 平移动画
            CGFloat toY = cell.center.y;
            CGFloat space = (toY - MiddleY);
            
            CGFloat scal = ABS(space);
            CABasicAnimation *translate = [CABasicAnimation animation];
            translate.keyPath = @"transform.translation.y";
            translate.fromValue = [NSNumber numberWithFloat:-space];
            translate.toValue = [NSNumber numberWithFloat:0];
            translate.duration = 0.5;
            translate.fillMode = kCAFillModeForwards;
            
            // 缩放动画
            CABasicAnimation *scale = [CABasicAnimation animation];
            scale.keyPath = @"transform.scale";
            scale.fromValue = [NSNumber numberWithFloat:1.0];
            scale.toValue = [NSNumber numberWithFloat:1.2 - scal/self.frame.size.height];
            scale.duration = 0.5;
            scale.fillMode = kCAFillModeForwards;
            
            //变色动画
            CABasicAnimation *alpha = [CABasicAnimation animation];
            alpha.keyPath = @"opacity";
            alpha.fromValue = [NSNumber numberWithFloat:0.3];
            alpha.toValue = [NSNumber numberWithFloat:0];
            alpha.duration = 0.5;
            alpha.fillMode = kCAFillModeForwards;
            
            
            [Ccell.layer addAnimation:translate forKey:nil];
            [Ccell.backView.layer addAnimation:alpha forKey:nil];
            [Ccell.scaleView.layer addAnimation:scale forKey:nil];

        }
    }

}
#pragma mark ScrollView Delegate Method Override
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.contentOffset.y != self.contentSize.height/3) {
        _isLoaded = YES;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastOffsetY = self.contentOffset.y;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = self.contentOffset;
    if (offset.y > lastOffsetY) {
       
        offset.y = (int)(offset.y/self.rowHeight + 1) * self.rowHeight;
    }else{
       
        offset.y = (int)(offset.y/self.rowHeight) * self.rowHeight;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setContentOffset:offset animated:YES];
    });    
}


@end
