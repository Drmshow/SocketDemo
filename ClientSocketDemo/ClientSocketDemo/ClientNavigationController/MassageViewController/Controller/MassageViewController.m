//
//  MassageViewController.m
//  MYAPP
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "MassageViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "MYModel.h"
#import "ModelFrame.h"
#import "MYCell.h"
#import "KeyBoardView.h"
#import "MBProgressHUD+DM.h"

MassageViewController *g_viewPage;

@interface MassageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    CFSocketRef _socket;
}

@property (nonatomic, strong) NSMutableArray *modelFrames;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KeyBoardView *keyBoardView;
@property (nonatomic, assign) BOOL massageing;
@property (nonatomic, assign) int titleIndex;
@property (nonatomic, assign) int iconBadgeNumber;
@property (nonatomic, strong) UILocalNotification *localNoti;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MassageViewController

#pragma mark -view cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MYCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.keyBoardView];
    [self startConnect];
    [self addNotificationCenter];
}

- (void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChangedWithNoti:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeNumber) name:@"BadgeNumberShouldBeZero" object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.modelFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark -懒加载

- (KeyBoardView *)keyBoardView
{
    if (!_keyBoardView) {
        _keyBoardView = [[KeyBoardView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
        _keyBoardView.layer.borderWidth = 0.5;
        _keyBoardView.layer.borderColor = [UIColor grayColor].CGColor;
        self.keyBoardView.textField.delegate = self;
    }
    return _keyBoardView;
}


- (NSMutableArray *)modelFrames
{
    if (!_modelFrames) {
        _modelFrames = [ModelFrame modelFrames];
    }
    return _modelFrames;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UILocalNotification *)localNoti
{
    if (!_localNoti) {
        _localNoti = [[UILocalNotification alloc] init];
        _localNoti.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
        _localNoti.soundName = UILocalNotificationDefaultSoundName;
    }
    return _localNoti;
}

- (void)keyBoardFrameChangedWithNoti:(NSNotification *)noti
{
    self.view.window.backgroundColor = self.tableView.backgroundColor;
    CGFloat animateDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] integerValue];
    CGRect keyBoardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyBoardFrame.origin.y - self.view.bounds.size.height);
    }];
}

#pragma mark -tableView数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelFrames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelFrame *modelFrame = self.modelFrames[indexPath.row];
    return modelFrame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.modelFrame = self.modelFrames[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    ModelFrame *modelFrame = self.modelFrames[indexPath.row];
    MYModel *model = modelFrame.model;
    if (model.receivedMassage) {
        [cell.juHua startAnimating];
    }
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.massageing) {
        [self.view endEditing:YES];
    }
}

#pragma mark -创建、链接socket

- (void)startConnect
{
    NSString *serverIp = @"127.0.0.1";
    [self createConnect:serverIp];
}

-(void)createConnect:(NSString*)strAddress
{
    CFSocketContext sockContext = {0,
        (__bridge void *)(self),
        NULL,
        NULL,
        NULL};
    _socket = CFSocketCreate(kCFAllocatorDefault,
                             PF_INET,
                             SOCK_STREAM,
                             IPPROTO_TCP,
                             kCFSocketConnectCallBack,
                             TCPClientConnectCallBack,
                             &sockContext
                             );
    if(_socket != NULL)
    {
        struct sockaddr_in addr4;
        memset(&addr4, 0, sizeof(addr4));
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(8888);
        addr4.sin_addr.s_addr = inet_addr([strAddress UTF8String]);
        
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
        CFSocketConnectToAddress(_socket,
                                 address,
                                 -1
                                 );
        CFRunLoopRef cRunRef = CFRunLoopGetCurrent();
        CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
        CFRunLoopAddSource(cRunRef,
                           sourceRef,
                           kCFRunLoopCommonModes
                           );
        CFRelease(sourceRef);
        NSLog(@"connect ok");
    }
}

static void TCPClientConnectCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    MassageViewController *client = (__bridge MassageViewController *)info;
    if (data != NULL)
    {
        [client setTitleIndex];
        [client setNavName];
        [MBProgressHUD showError:@"服务器连接失败"];
        return;
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [client setAucceedNavName];
            [MBProgressHUD showMessage:@"服务器连接成功"];
            [client sendServerSucceed];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        g_viewPage = client;
        [client startReadThread];
        
    }
}

- (void)startReadThread
{
    NSThread *InitThread = [[NSThread alloc]initWithTarget:self selector:@selector(initThreadFunc:) object:self];
    [InitThread start];
}
- (void)initThreadFunc:(id)sender
{
    while (1) {
        [self readStream];
    }
}

- (void)setNavName
{
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(test1) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)test1{
    if (self.titleIndex == 0) {
        [self startConnect];
    }
    self.navigationItem.title = [NSString stringWithFormat:@"连接中。。%d",self.titleIndex --];
}

- (void)setTitleIndex
{
    self.titleIndex = 15;
    [self.timer invalidate];
}

- (void)setAucceedNavName
{
    [self.timer invalidate];
    self.navigationItem.title = @"聊天";
}

#pragma mark -发送和接收消息

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [self sendMessageWithMassage:textField.text];
        [self setMassageWith:textField.text];
    }
    return YES;
}


- (void)sendServerSucceed
{
    [self sendMessageWithMassage:@"IP:127.0.0.1(客户端连接成功)"];
}

- (void)setMassageWith:(NSString *)str
{
    self.massageing = YES;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm";
    NSString *dateStr = [formatter stringFromDate:date];
    [self addMassageWithStr:str andType:0 andTime:dateStr andReceivedMassage:1];
}



- (void)addMassageWithStr:(NSString *)str andType:(int)integer andTime:(NSString *)time andReceivedMassage:(int)receivedMassage
{
    ModelFrame *modelFrame = [[ModelFrame alloc] init];
    MYModel *model = [[MYModel alloc] init];
    model.text = str;
    model.type = integer;
    model.receivedMassage = receivedMassage;
    ModelFrame *lastModelFrame = self.modelFrames.lastObject;
    NSString *lastStr = lastModelFrame.model.time;
    if ([lastStr isEqualToString:time]) {
        model.sameTime = 1;
    }else{
        model.sameTime = 0;
    }
    model.time = time;
    modelFrame.model = model;
    [self.modelFrames addObject:modelFrame];
    [self.tableView reloadData];
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.modelFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    self.massageing = NO;
    self.keyBoardView.textField.text = nil;
}

- (void)readStream
{
    char buffer[1024];
    NSString *str;
    recv(CFSocketGetNative(_socket), buffer, sizeof(buffer), 0);
    {
        str = [NSString stringWithUTF8String:buffer];
        if (str == nil) {
            [self startConnect];
            [MBProgressHUD showError:@"服务器断开连接"];
        }else{
            [self performSelectorOnMainThread:@selector(showMsg:) withObject:str waitUntilDone:NO];
        }
    }
}

- (void)showMsg:(NSString *)str
{
    NSString *massage = str;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm";
    NSString *dateStr = [formatter stringFromDate:date];
    if ([massage isEqualToString:@"received1.2.3"]) {
        for (ModelFrame *modelFrame in self.modelFrames) {
            MYModel *model = modelFrame.model;
            model.receivedMassage = 0;
        }
        [self.tableView reloadData];
    }else{
        self.iconBadgeNumber ++;
        [self addLocalNotification:massage];
        [self addMassageWithStr:massage andType:1 andTime:dateStr andReceivedMassage:0];
        [self sendMessageWithMassage:@"received1.2.3"];
    }
}

- (void)sendMessageWithMassage:(NSString *)str{
    const char *data = [str UTF8String];
    if ([self.navigationItem.title isEqual:@"聊天"]) {
        send(CFSocketGetNative(_socket), data, strlen(data) + 1, 0);
    }
}

- (void)addLocalNotification:(NSString *)str
{
    self.localNoti.alertBody = str;
    self.localNoti.applicationIconBadgeNumber = self.iconBadgeNumber;
    [[UIApplication sharedApplication] scheduleLocalNotification:_localNoti];
}

- (void)setBadgeNumber
{
    self.iconBadgeNumber = 0;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
}

@end
