//
//  LoginViewModel.h
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/3.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

#pragma mark - 业务数据
/**
 用户名
 */
@property (nonatomic, copy)NSString *userName;

/**
 密码
 */
@property (nonatomic, copy)NSString *password;

#pragma mark - 命令
/**
 登录命令
 */
@property (nonatomic, strong) RACCommand *loginCommand;

@end
