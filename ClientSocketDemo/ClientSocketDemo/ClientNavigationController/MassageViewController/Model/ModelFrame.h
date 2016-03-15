//
//  ModelFrame.h
//  qq聊天界面
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYModel.h"

@interface ModelFrame : NSObject

@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, assign) CGRect timeFrame;
@property (nonatomic, assign) CGRect iconFrame;
@property (nonatomic, assign) CGRect juHuaFrame;

@property (nonatomic, strong) MYModel *model;

@property (nonatomic, assign) CGFloat cellHeight;

+ (NSMutableArray *)modelFrames;

@end
