//
//  ViewController.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/2.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *titleArray;

@property (nonatomic, strong)NSArray *subTitleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        _subTitleArray = @[@"模型 - 视图 - 控制器通常用于开发将应用程序划分为三个互连部分的软件。 这是为了将信息的内部表示与信息呈现给用户并从用户接受的方式分开。MVC设计模式将这些主要组件分离，从而实现高效的代码重用和并行开发。", @"模型 - 视图 - 展示器（MVP）是模型 - 视图 - 控制器（MVC）架构模式的派生，主要用于构建用户界面。", @"MVVM有助于将图形用户界面的开发 - 无论是通过标记语言还是GUI代码 - 与业务逻辑或后端逻辑（数据模型）的开发分离开来。 MVVM的视图模型是一个值转换器，意味着视图模型负责从模型中暴露（转换）数据对象，以便轻松管理和呈现对象。 在这方面，视图模型比视图更具模型，并且处理大多数（如果不是全部）视图的显示逻辑。视图模型可以实现中介模式，组织对视图支持的一组用例的后端逻辑的访问。"];
    }
    return _subTitleArray;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
