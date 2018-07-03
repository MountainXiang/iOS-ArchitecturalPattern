//
//  ViewController.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/2.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import "MVCViewController.h"
#import "MVVMTableViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *subTitleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"iOS架构模式";
}

#pragma mark - Lazy Loader
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"MVC", @"MVP", @"MVVM"];
    }
    return _titleArray;
}

- (NSArray *)subTitleArray {
    if (!_subTitleArray) {
        _subTitleArray = @[@"将模型-视图-控制器分离，从而实现高效的代码重用和并行开发。", @"模型-视图-展示器(MVP)是MVC的派生，用于构建用户界面。", @"将图形用户界面与业务逻辑或后端逻辑（数据模型）分离开来。"];
    }
    return _subTitleArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

static NSString *cellID = @"cellIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.subTitleArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            MVCViewController *vc = [[MVCViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            MVVMTableViewController *vc = [[MVVMTableViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
