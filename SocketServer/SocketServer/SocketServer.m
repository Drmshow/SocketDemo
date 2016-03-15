//
//  ViewController.m
//  sever
//
//  Created by drmshow on 16/3/10.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "SocketServer.h"
CFWriteStreamRef outputStream;
CFSocketRef s;
int num = 0;

@interface SocketServer ()

@property (nonatomic, strong) NSMutableArray *sendMassages;

@end

@implementation SocketServer

- (NSMutableArray *)sendMassages
{
    if (!_sendMassages) {
        _sendMassages = [NSMutableArray array];
    }
    return _sendMassages;
}

- (int)setupSocket
{
    CFSocketContext sockContext = {0,
        (__bridge void *)(self),
        NULL,
        NULL,
        NULL};
    _socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, TCPServerAcceptCallBack, &sockContext);
    s = _socket;
    if (NULL == _socket) {
        return 0;
    }
    
    int optval = 1;
    setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR,
               (void *)&optval, sizeof(optval));
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(8888);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
    if (kCFSocketSuccess != CFSocketSetAddress(_socket, address))
    {
        if (_socket)
            CFRelease(_socket);
        _socket = NULL;
        return 0;
    }
    CFRunLoopRef cfRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);
    CFRelease(source);
    
    return 1;
}

- (void)sendMessage:(NSString *)str
{
    [self.sendMassages addObject:str];
    char mychar[300];
    strcpy(mychar,(char *)[str UTF8String]);
      uint8_t * uin8b = (uint8_t *)mychar;
    if (outputStream != NULL)
    {
        CFWriteStreamWrite(outputStream, uin8b, strlen(mychar) + 1);
    }
    else {
    }
}

- (void)startServer
{
    int res = [self setupSocket];
    if (!res) {
        exit(1);
    }
    CFRunLoopRun();
}

- (void)showMsgOnMainPage:(NSString*)strMsg
{
    [self.delegate showMsg:strMsg];
}

- (NSString *)lastString
{
    NSString *lastString = self.sendMassages.lastObject;
    [self.sendMassages removeLastObject];
    return lastString;
}

static void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    if (kCFSocketAcceptCallBack == type)
    {
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];
        socklen_t nameLen = sizeof(name);
        if (0 != getpeername(nativeSocketHandle, (struct sockaddr *)name, &nameLen)) {
            NSLog(@"error");
            exit(1);
        }
        CFReadStreamRef iStream;
        CFWriteStreamRef oStream;
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &iStream, &oStream);
        if (iStream && oStream)
        {
            CFStreamClientContext streamContext = {0, info, NULL, NULL};
            if (!CFReadStreamSetClient(iStream, kCFStreamEventHasBytesAvailable,readStream, &streamContext))
            {
                exit(1);
            }
            if (!CFWriteStreamSetClient(oStream, kCFStreamEventCanAcceptBytes, writeStream, &streamContext))
            {
                exit(1);
            }
            CFReadStreamScheduleWithRunLoop(iStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
            CFWriteStreamScheduleWithRunLoop(oStream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
            CFReadStreamOpen(iStream);
            CFWriteStreamOpen(oStream);
        } else
        {
            close(nativeSocketHandle);
        }
    }
}

void readStream(CFReadStreamRef stream, CFStreamEventType eventType, void *clientCallBackInfo)
{
    UInt8 buff[255];
    CFReadStreamRead(stream, buff, 255);
    NSString * readStr= [NSString stringWithCString:(char *)buff encoding:NSUTF8StringEncoding];
    if ([readStr isEqualToString:@"received1.2.3"]) {
        SocketServer *info = (__bridge SocketServer*)clientCallBackInfo;
        NSString *lastString = [info lastString];
        NSString *strMsg = [NSString stringWithFormat:@"客户端已收到消息：%@",lastString];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![strMsg isEqualToString:@"客户端已收到消息：received1.2.3"]) {
                [info showMsgOnMainPage:strMsg];
            }
        });
    }else{
        NSString *strMsg = [[NSString alloc] initWithFormat:@"客户端传来消息：%@",readStr];
        if (readStr == nil) {
            strMsg = @"客户端传来消息：(客户端断开连接)";
        }
        SocketServer *info = (__bridge SocketServer*)clientCallBackInfo;
        [info showMsgOnMainPage:strMsg];
    }
}



void writeStream (CFWriteStreamRef stream, CFStreamEventType eventType, void *clientCallBackInfo)
{
    outputStream = stream;
}
@end
