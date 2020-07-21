//
//  FKViewControllerProtocol.h
//  FXXKBaseMVVM
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 为 ViewController 绑定方法协议
 */
@protocol FKViewControllerProtocol <NSObject>

#pragma mark - 方法绑定
@required
/// 初始化数据
- (void)fk_initialDefaultsForController;

/// 绑定 vm
- (void)fk_bindViewModelForController;

/// 创建视图
- (void)fk_createViewForConctroller;

/// 配置导航栏
- (void)fk_configNavigationForController;

@end
