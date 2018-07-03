//
//  BaseNavigationController.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/3.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overwrite
//在Info.plist中View controller-based status bar appearance设置选项，设置为YES或者删除该设置选项才能生效
//解决嵌套UINavigationController设置导航样式无效的问题
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

//在Info.plist中View controller-based status bar appearance设置选项，设置为YES或者删除该设置选项才能生效
//解决嵌套UINavigationController设置导航隐藏无效的问题
- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
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
