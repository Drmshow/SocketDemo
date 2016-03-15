//
//  MBProgressHUD+DM.h
//  MYAPP
//
//  Created by admin on 16/3/15.
//  Copyright © 2016年 drmshow. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (DM)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end

