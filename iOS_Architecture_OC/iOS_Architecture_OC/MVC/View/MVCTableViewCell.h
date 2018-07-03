//
//  MVCTableViewCell.h
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/3.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MVCModel;

@interface MVCTableViewCell : UITableViewCell

@property (nonatomic, strong) MVCModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
