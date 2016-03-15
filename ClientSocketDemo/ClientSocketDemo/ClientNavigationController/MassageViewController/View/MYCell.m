//
//  MYCell.m
//  qq聊天界面
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "MYCell.h"

@implementation MYCell

- (UIActivityIndicatorView *)juHua
{
    if (!_juHua) {
        _juHua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:_juHua];
    }
    return _juHua;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)textButton
{
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton.titleLabel.numberOfLines = 1;
        [_textButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _textButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _textButton.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        [self.contentView addSubview:_textButton];
    }
    return _textButton;
}

- (void)setModelFrame:(ModelFrame *)modelFrame
{
    self.timeLabel.frame = modelFrame.timeFrame;
    self.timeLabel.text = modelFrame.model.time;
    
    if (modelFrame.model.type) {
        self.iconImageView.image = [UIImage imageNamed:@"20130616030823418"];
        self.iconImageView.frame = modelFrame.iconFrame;
    }else{
        self.iconImageView.image = [UIImage imageNamed:@"123456"];
        self.iconImageView.frame = modelFrame.iconFrame;
    }
    
    if (modelFrame.model.type) {
        [self.textButton setBackgroundImage:[MYCell resizeWithImageName:@"chat_recive_nor"] forState:UIControlStateNormal];
        [self.textButton setBackgroundImage:[MYCell resizeWithImageName:@"chat_recive_press_pic"] forState:UIControlStateHighlighted];
    }else{
        [self.textButton setBackgroundImage:[MYCell resizeWithImageName:@"chat_send_nor"] forState:UIControlStateNormal];
        [self.textButton setBackgroundImage:[MYCell resizeWithImageName:@"chat_send_press_pic"] forState:UIControlStateHighlighted];
    }
    
    self.juHua.frame = modelFrame.juHuaFrame;
    [self.textButton setTitle:modelFrame.model.text forState:UIControlStateNormal];
    self.textButton.frame = modelFrame.textFrame;
}

+ (UIImage *)resizeWithImageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    CGFloat x = image.size.width *0.5;
    CGFloat y = image.size.height *0.5;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(y, x, y, x)];
    return image;
}

@end
