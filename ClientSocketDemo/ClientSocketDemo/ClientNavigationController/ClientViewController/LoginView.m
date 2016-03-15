//
//  LoginView.m
//  MYAPP
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "LoginView.h"
#import "MBProgressHUD+DM.h"

@interface LoginView() <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *accountLable;
@property (nonatomic, strong) UILabel *pwdLable;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pwdLable];
        [self addSubview:self.accountLable];
        [self addSubview:self.pwdTextField];
        [self addSubview:self.accountTextField];
        [self addSubview:self.loginButton];
        self.loginButton.enabled = NO;
    }
    return self;
}

#pragma mark －懒加载控件

- (UILabel *)accountLable
{
    if (!_accountLable) {
        _accountLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, 40, 20)];
        _accountLable.text = @"账号:";
        _accountLable.textAlignment = NSTextAlignmentCenter;
        _accountLable.textColor = [UIColor blueColor];
    }
    return _accountLable;
}

- (UILabel *)pwdLable
{
    if (!_pwdLable) {
        _pwdLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 93, 40, 20)];
        _pwdLable.text = @"密码:";
        _pwdLable.textAlignment = NSTextAlignmentCenter;
        _pwdLable.textColor = [UIColor blueColor];
    }
    return _pwdLable;
}


- (UITextField *)accountTextField
{
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.accountLable.frame) + 20, 60, self.bounds.size.width * 0.5, 25)];
        _accountTextField.borderStyle = UITextBorderStyleRoundedRect;
        _accountTextField.placeholder = @"请输入账号（＊）";
        _accountTextField.clearButtonMode = UITextFieldViewModeAlways;
        [_accountTextField becomeFirstResponder];
        _accountTextField.delegate = self;
        [_accountTextField addTarget:self action:@selector(keyboardDidChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _accountTextField;
    
}

- (UITextField *)pwdTextField
{
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.accountLable.frame) + 20, 90, self.bounds.size.width * 0.5, 25)];
        _pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
        _pwdTextField.placeholder = @"请输入密码（＊）";
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.clearButtonMode = UITextFieldViewModeAlways;
        _pwdTextField.delegate = self;
        [_pwdTextField addTarget:self action:@selector(keyboardDidChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _pwdTextField;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(self.bounds.size.width * 0.5 - 20, CGRectGetMaxY(self.pwdTextField.frame) + 30, 40, 20);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

#pragma mark -控件事件

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)login
{
    if ([self.accountTextField.text isEqualToString:@"1"] && [self.pwdTextField.text isEqualToString:@"1"]) {
        [MBProgressHUD showMessage:@"登录中。。"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            self.accountTextField.text = @"";
            self.pwdTextField.text = @"";
            [self.accountTextField becomeFirstResponder];
            self.loginButton.enabled = NO;
            if ([self.delegate respondsToSelector:@selector(loginView:)]) {
                [self.delegate loginView:self];
            }
        });
    }else{
        [MBProgressHUD showError:@"账号或者密码错误"];
    }
}

- (void)keyboardDidChanged
{
//    self.loginButton.enabled = (self.pwdTextField.text.length && self.accountTextField.text.length);
    self.loginButton.enabled = YES;
}

@end
