//
//  CustomCell.m
//  LeTableView
//
//  Created by joey on 16/11/11.
//  Copyright © 2016年 com.joey. All rights reserved.
//

#import "CustomCell.h"
#import <Foundation/Foundation.h>
@implementation CustomCell

-(void)layoutSubviews{
    [self titleLabelAnimation];
}
- (void)awakeFromNib {
    [super awakeFromNib];
//使得titleLabel的内容不能超出背景
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRect:self.titleBackView.bounds].CGPath;
    self.titleBackView.layer.mask = maskLayer;

//设置分割线样式
    self.separatorView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.separatorView.layer.shadowOpacity = 0.5f;
    self.separatorView.layer.shadowOffset = CGSizeMake(0, 1);
    
}

#pragma mark titleLabel Animation
-(void)titleLabelAnimation{
//先计算titleLabel的文字size，如果超出背景宽度,做动画显示全部内容
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:self.titleLabel.text];
    NSRange range = NSMakeRange(0, attr.length);
    NSDictionary* dic = [attr attributesAtIndex:0 effectiveRange:&range];

    CGSize size =[self.titleLabel.text boundingRectWithSize:CGSizeMake(1000, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
  
    if (size.width > self.titleBackView.frame.size.width) {
    
        CGFloat moveDistance =size.width-self.titleBackView.frame.size.width;
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
        keyAnimation.keyPath = @"transform.translation.x";
        keyAnimation.values = @[@(0),@(-moveDistance),@(0)];
        keyAnimation.repeatCount = NSIntegerMax;
        keyAnimation.duration = 0.1*moveDistance;
        keyAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.5 :0.5]];
        [self.titleLabel.layer addAnimation:keyAnimation forKey:@"keyAnimation"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



@end
