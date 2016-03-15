//
//  ViewController.m
//  MYAPP
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "ViewController.h"
#import "BaseNavigationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    BaseNavigationController *baseNav = [[BaseNavigationController alloc] init];
    
    [self addChildViewController:baseNav];
}

@end
