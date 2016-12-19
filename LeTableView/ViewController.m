//
//  ViewController.m
//  LeTableView
//
//  Created by joey on 16/11/9.
//  Copyright © 2016年 com.joey. All rights reserved.
//
#define SW [[UIScreen mainScreen]bounds].size.width
#define SH [[UIScreen mainScreen]bounds].size.height

#import "ViewController.h"
#import "LeTableView.h"
#import "CustomCell.h"
#import "LeScrollView.h"

static NSString * customCellID = @"customCell";
CGFloat const KTableHeight=500.0f;

@interface ViewController ()<UITableViewDelegate,
                             UITableViewDataSource,
                             UIScrollViewDelegate,
                             LeChangeDelegate>
@property (nonatomic, strong) LeTableView *tableView;
@property (nonatomic, strong) LeScrollView *titleScroll;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ViewController{
    BOOL isLoaded;
    CGPoint lastPoint;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleScroll];
    [self.view addSubview:self.tableView];
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithArray:
                    @[@"2016韦礼安“硬戳”Live Show 新专辑演唱会",
                      @"蒙面唱将猜猜猜",
                      @"华晨宇火星演唱会",
                      @"熊孩子儿歌之歌唱祖国",
                      @"盖世英雄"]];
    }
    return _dataArr;
}
- (LeTableView *)tableView {
    if(!_tableView) {
        _tableView = [[LeTableView alloc] initWithFrame:CGRectMake(0, SH-KTableHeight, SW, KTableHeight)
                    style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = KTableHeight/5;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:customCellID];
    }
    return _tableView;
}

- (LeScrollView *)titleScroll{
    if (!_titleScroll) {
        NSArray *dataArr = @[@"儿童文学",@"收藏",@"热门啊",@"音乐天天",@"小说",@"直播",@"情感",];
        _titleScroll = [[LeScrollView alloc]initWithFrame:CGRectMake(0, SH-KTableHeight-50, SW, 50) withDataArr:dataArr];
        _titleScroll.delegate = self;
        _titleScroll.changeDelegate = self;
    }
    return _titleScroll;
}
#pragma mark RequestData
- (void)requestData{}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell * cell = [self.tableView dequeueReusableCellWithIdentifier:customCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.dataArr[indexPath.row];
    return cell;
}
#pragma mark LeChangeDelegate
- (void)changeData:(NSString *)dataName{
    self.tableView = nil;
    [self.view addSubview:self.tableView];
}

@end
