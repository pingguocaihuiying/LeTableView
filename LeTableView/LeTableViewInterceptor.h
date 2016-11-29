//
//  LeTableViewInterceptor.h
//  LeTableView
//
//  Created by joey on 16/11/9.
//  Copyright © 2016年 com.joey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeTableViewInterceptor : NSObject

@property (nonatomic, weak) id middleMan;

@property (nonatomic, weak) id dataSource;

@property (nonatomic, weak) id delegate;
@end
