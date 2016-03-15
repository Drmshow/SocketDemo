//
//  ViewController.m
//  sever
//
//  Created by drmshow on 16/3/10.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    server = [[SocketServer alloc] init];
    server.delegate = self;
    self.textFiled.delegate = self;
}
- (IBAction)sendMessageToClient:(id)sender {
    if (self.textFiled.text.length) {
        [server sendMessage:self.textFiled.text];
        self.textFiled.text = nil;
    }
    
}

- (IBAction)touchStartServer:(id)sender {
    NSThread *InitThread = [[NSThread alloc]initWithTarget:self selector:@selector(initThreadFunc:) object:self];
    [InitThread start];
    self.textView.text = @"服务启动成功";
}

- (void)initThreadFunc:(id)sender
{
    [server startServer];
}

- (void)showMsg:(NSString*)strMsg
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [server sendMessage:@"received1.2.3"];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [NSString stringWithFormat:@"%@\n%@",self.textView.text, strMsg];    
    });
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textFiled.text.length) {
        [server sendMessage:self.textFiled.text];
        self.textFiled.text = nil;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
