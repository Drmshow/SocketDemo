//
//  ViewController.m
//  sever
//
//  Created by drmshow on 16/3/10.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "ViewController.h"


@class ViewController;
@interface SocketServer : NSObject
{
    CFSocketRef _socket;
}
@property (weak, nonatomic) ViewController *delegate;
-(void) startServer;
-(void) sendMessage:(NSString *)str;
@end
