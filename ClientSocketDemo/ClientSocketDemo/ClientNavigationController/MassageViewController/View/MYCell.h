//
//  MYCell.h
//  qq聊天界面
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelFrame.h"

@interface MYCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *textButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIActivityIndicatorView *juHua;
@property (nonatomic, assign) BOOL receivedMassage;

@property (nonatomic, strong) ModelFrame *modelFrame;

@end
