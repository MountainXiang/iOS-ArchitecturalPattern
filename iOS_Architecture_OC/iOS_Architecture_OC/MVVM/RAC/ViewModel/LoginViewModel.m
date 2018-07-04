//
//  LoginViewModel.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/3.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginRequest.h"
#import "CustomedYTKRequest+Rac.h"

@implementation LoginViewModel

#pragma mark - Getter
- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            LoginRequest *request = [[LoginRequest alloc] initWithUserName:self.userName password:self.password];
            return [[[request rac_signal] doNext:^(id  _Nullable x) {
                //登录成功
//                [USER_DEFAULT setBool:YES forKey:UD_KEY_LOGIN];
                [SVProgressHUD fk_displaySuccessWithStatus:@"登录成功"];
            }] materialize];
        }];
    }
    return _loginCommand;
}

#pragma mark - FKViewModelProtocol
- (void)fk_initializeForViewModel {
    RAC(self, isLoginEnable) = [[RACSignal combineLatest:@[RACObserve(self, userName),RACObserve(self, password)]] map:^id _Nullable(RACTuple * _Nullable value) {
        RACTupleUnpack(NSString *account, NSString *pwd) = value;
        return @(account && pwd && account.length && pwd.length);
    }];
}

@end
