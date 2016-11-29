//
//  CustomCell.h
//  LeTableView
//
//  Created by joey on 16/11/11.
//  Copyright © 2016年 com.joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *scaleView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *indictorImage;
@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end
