//
//  LoginViewController.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *pwdSecuritySwitch;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong)LoginViewModel *loginVM;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - FKViewControllerProtocol

/*
 /// 初始化数据
 - (void)fk_initialDefaultsForController;
 
 /// 绑定 vm
 - (void)fk_bindViewModelForController;
 
 /// 创建视图
 - (void)fk_createViewForConctroller;
 
 /// 配置导航栏
 - (void)fk_configNavigationForController;
 */

/// 初始化数据
- (void)fk_initialDefaultsForController {
    [self setLoginVM:[[LoginViewModel alloc] initWithParams:self.params]];
}

/// 绑定 vm
- (void)fk_bindViewModelForController {
    @weakify(self);
    [[_pwdSecuritySwitch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        // 密码显示和切换
        self.pwdSecuritySwitch.selected = !self.pwdSecuritySwitch.selected;
        self.pwdTF.secureTextEntry = !self.pwdSecuritySwitch.selected;
    }];
    
    // 绑定账号
    RAC(self.loginVM, userName) = [self.accountTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        //限制账户长度
        if (value.length > 10) {
            self.accountTF.text = [value substringToIndex:10];
        }
        return self.accountTF.text;
    }];
    
    // 绑定密码
    RAC(self.loginVM, password) = [self.pwdTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        //限制密码长度
        if (value.length > 25) {
            self.pwdTF.text = [value substringToIndex:25];
        }
        return self.pwdTF.text;
    }];
    
    // 监听Return事件
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        RACTupleUnpack(UITextField *textfield) = x;
        [textfield resignFirstResponder];
        if (self.loginVM.isLoginEnable) {
            [self.loginVM.loginCommand execute:nil];
        }
    }];
    
    // 监听密码显示切换
}

/// 创建视图
- (void)fk_createViewForConctroller {
    
}

/// 配置导航栏
- (void)fk_configNavigationForController {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
