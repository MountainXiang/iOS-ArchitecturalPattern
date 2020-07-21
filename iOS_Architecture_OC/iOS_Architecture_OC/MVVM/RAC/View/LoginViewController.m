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

@property (weak, nonatomic) IBOutlet UIScrollView *scollView;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *pwdSecuritySwitch;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;

@property (nonatomic, strong)LoginViewModel *loginVM;

@property (nonatomic, strong) UIGestureRecognizer *tap;


@end

@implementation LoginViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"登录";
    
    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0x0177D7)] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:[HEX_RGB(0x0177D7) colorWithAlphaComponent:0.3] ] forState:UIControlStateDisabled];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:self.tap];
}

- (void)dealloc {
    DLOG_METHOD
}

#pragma mark - FKViewControllerProtocol
/// 初始化数据
- (void)fk_initialDefaultsForController {
    [self setLoginVM:[[LoginViewModel alloc] initWithParams:self.params]];
}

/// 绑定 vm
- (void)fk_bindViewModelForController {
    @weakify(self);
    //监听登录按钮是否可点击
    RAC(self.loginBtn, enabled) = RACObserve(self.loginVM, isLoginEnable);
    
    // 监听密码显示切换
    [[_pwdSecuritySwitch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.pwdSecuritySwitch.selected = !self.pwdSecuritySwitch.selected;
        self.pwdTF.secureTextEntry = !self.pwdSecuritySwitch.selected;
    }];
    
    // 监听账号
    RAC(self.loginVM, userName) = [self.accountTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        //限制账户长度
        if (value.length > 10) {
            self.accountTF.text = [value substringToIndex:10];
        }
        return self.accountTF.text;
    }];
    
    // 监听密码
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
        
        if (textfield == self.accountTF) {
            [self.pwdTF becomeFirstResponder];
        } else if (textfield == self.pwdTF) {
            if (self.loginVM.isLoginEnable) {
                [self.loginVM.loginCommand execute:nil];
            } else {
                if (self.loginVM.userName.length == 0) {
                    [SVProgressHUD fk_displayErrorWithStatus:@"请输入账户"];
                } else if (self.loginVM.password.length == 0) {
                    [SVProgressHUD fk_displayErrorWithStatus:@"请输入密码"];
                }
            }
        }
    }];
    
    // 监听登录信号
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:1.0f] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self fk_hideKeyBoard];
        if (self.loginVM.isLoginEnable) {
            [self.loginVM.loginCommand execute:nil];
        } else {
            if (self.loginVM.userName.length == 0) {
                [SVProgressHUD fk_displayErrorWithStatus:@"请输入账户"];
            } else if (self.loginVM.password.length == 0) {
                [SVProgressHUD fk_displayErrorWithStatus:@"请输入密码"];
            }
        }
    }];
    
    // 监听登录信号是否在执行
    [[self.loginVM.loginCommand.executing skip:1.0f] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.loginIndicator startAnimating];
            [self.loginBtn setTitle:@"" forState:UIControlStateNormal];
        } else {
            // 2秒后移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.loginIndicator stopAnimating];
                [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            });
        }
    }];
    
    
    // 监听键盘弹出
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        //获取动画时长
        NSNumber *keyboardAnimationDuration = [[x userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval duration = [keyboardAnimationDuration doubleValue];
        if (self.accountTF.isFirstResponder) {
            [UIView animateWithDuration:duration animations:^{
                self.scollView.contentOffset = CGPointMake(0, 100);
            }];
        } else if (self.pwdTF.isFirstResponder) {
            [UIView animateWithDuration:duration animations:^{
                self.scollView.contentOffset = CGPointMake(0, 120);
            }];
        }
    }];
    
    // 监听键盘收起
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        //获取动画时长
        NSNumber *keyboardAnimationDuration = [[x userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval duration = [keyboardAnimationDuration doubleValue];
        [UIView animateWithDuration:duration animations:^{
            self.scollView.contentOffset = CGPointZero;
        }];
    }];
}

/// 创建视图
- (void)fk_createViewForConctroller {
    
}

/// 配置导航栏
- (void)fk_configNavigationForController {
    
}

#pragma mark - Events
- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
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
