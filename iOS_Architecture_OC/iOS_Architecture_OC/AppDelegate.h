//
//  AppDelegate.h
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/2.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

#pragma mark - 系统适配
@interface AppDelegate(Adaption)
- (void)configAdaption;
@end

#pragma mark - 初始化 SVProgressHUD 配置
@interface AppDelegate (SVProgressHUD)
- (void)configSVProgressHUD;
@end

#pragma mark - YTKNetworking 接口地址配置
@interface AppDelegate(NetworkApiEnv)
- (void)configNetworkApiEnv;
@end
