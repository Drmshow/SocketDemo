//
//  ClientViewController.m
//  MYAPP
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "ClientViewController.h"
#import "LoginView.h"
#import "MassageViewController.h"

@interface ClientViewController ()<LoginViewDelegate>

@end

@implementation ClientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect loginFrame = {0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64};
    LoginView *loginview = [[LoginView alloc] initWithFrame:loginFrame];
    loginview.backgroundColor = [UIColor whiteColor];
    loginview.delegate = self;
    [self.view addSubview:loginview];
}

- (void)loginView:(LoginView *)view
{
    MassageViewController *vc = [[MassageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
