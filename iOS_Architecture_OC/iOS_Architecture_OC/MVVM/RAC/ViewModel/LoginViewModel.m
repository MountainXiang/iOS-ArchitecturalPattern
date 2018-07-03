//
//  LoginViewModel.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/3.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

#pragma mark - Getter
- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return nil;
        }];
    }
    return _loginCommand;
}

@end
