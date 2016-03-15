//
//  ViewController.h
//  sever
//
//  Created by drmshow on 16/3/10.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SocketServer.h"

@class SocketServer;

@interface ViewController : UIViewController
{
    SocketServer *server;
}
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)sendMessageToClient:(id)sender;
- (IBAction)touchStartServer:(id)sender;
- (void)showMsg:(NSString*)strMsg;
@end

