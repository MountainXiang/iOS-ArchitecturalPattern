//
//  AppDelegate.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/2.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 基础配置
//    [self configAdaption];
    [self configSVProgressHUD];
    [self configNetworkApiEnv];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

#pragma mark - 系统适配
@implementation AppDelegate(Adaption)

- (void)configAdaption
{
    if (@available(iOS 11.0, *)) {//适配iOS11
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UIWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [WKWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
    }
}
@end

#pragma mark - 初始化 SVProgressHUD 配置
@implementation AppDelegate (SVProgressHUD)

- (void)configSVProgressHUD
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setRingThickness:4];
    [SVProgressHUD setMinimumSize:CGSizeMake(80, 80)];
}

@end

#pragma mark - YTKNetworking 接口地址配置
@implementation AppDelegate(NetworkApiEnv)

- (void)configNetworkApiEnv
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    if (DEBUG) {
        config.debugLogEnabled = YES;
    }else
    {
        config.debugLogEnabled = NO;
    }
    config.baseUrl = @"http://www.baidu.com";
    config.cdnUrl = @"http://www.baidu.com";
}
@end
