//
//  LoginView.h
//  MYAPP
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginView;

@protocol LoginViewDelegate <NSObject>

@optional
- (void)loginView:(LoginView *)view;

@end

@interface LoginView : UIView

@property (nonatomic, weak) id<LoginViewDelegate> delegate;

@end
