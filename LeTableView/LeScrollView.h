//
//  LeScrollView.h
//  LeTableView
//
//  Created by joey on 16/11/14.
//  Copyright © 2016年 com.joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol LeChangeDelegate<NSObject>

@optional
-(void)changeData:(NSString *)dataName;

@end


@interface LeScrollView : UIScrollView

@property (nonatomic, assign) id <LeChangeDelegate>changeDelegate;

- (id)initWithFrame:(CGRect)frame withDataArr:(NSArray *)arr;

@end
