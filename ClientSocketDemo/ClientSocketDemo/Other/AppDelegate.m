//
//  AppDelegate.m
//  MYAPP
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "ClientViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ClientViewController *clientVc = [[ClientViewController alloc] init];
    clientVc.title = @"登录";
    BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:clientVc];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = baseNav;
    [self.window makeKeyAndVisible];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [self.window endEditing:YES];
    [self.window endEditing:YES];
    __block UIBackgroundTaskIdentifier bgTask;// 后台任务标识
    
    // 结束后台任务
    void (^endBackgroundTask)() = ^(){
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    };
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        endBackgroundTask();
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BadgeNumberShouldBeZero" object:nil];
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
