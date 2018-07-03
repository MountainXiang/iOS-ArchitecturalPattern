//
//  MVCViewController.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/3.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "MVCViewController.h"
#import "MVCTableViewCell.h"
#import "MVCModel.h"

@interface MVCViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据源

@end

@implementation MVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"MVC";
    
    self.tableView.estimatedRowHeight = 400.f;
    [self loadData];
    [self.tableView reloadData];
}

#pragma mark - Load Data
- (void)loadData {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSArray <NSString *>*names = @[@"时光丶锁定在过往曾经つ",@"▍凉冬空巷°",@"ㄙdε犭戝",@"嘴角上揚ぃ读不出の漃寞",@"╭巴黎天空上苦涩的回忆"];
    for (NSInteger i = 0; i < 5; i ++) {
        NSDictionary *dict = @{@"logo":[NSString stringWithFormat:@"logo_%ld", i+1],
                               @"name":names[i],
                               @"timeStamp":[formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:random()%10000]],
                               @"picture":[NSString stringWithFormat:@"picture_%ld", i+1]
                               };
        MVCModel *model = [[MVCModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
}

#pragma mark - Lazy Loader
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MVCTableViewCell *cell = [MVCTableViewCell cellWithTableView:tableView];
    MVCModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
