//
//  KeyBoardView.m
//  qq聊天界面
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "KeyBoardView.h"

@interface KeyBoardView () <UITextFieldDelegate>

@end

@implementation KeyBoardView

- (UIButton *)talkButton
{
    if (!_talkButton) {
        _talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_talkButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateHighlighted];
        [_talkButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
        [self addSubview:_talkButton];
        
    }
    return _talkButton;
}

- (UIButton *)faceButton
{
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_press"] forState:UIControlStateHighlighted];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
        [self addSubview:_faceButton];
    }
    return _faceButton;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
        
        [self addSubview:_addButton];
    }
    return _addButton;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        [_textField setBackground:[UIImage imageNamed:@"chat_bottom_textfield"]];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.delegate = self;
        [self addSubview:_textField];
    }
    return _textField;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.talkButton.frame = CGRectMake(5, 5, 34, 34);
    self.addButton.frame = CGRectMake(self.frame.size.width - 39, 5, 34, 34);
    self.faceButton.frame = CGRectMake(self.bounds.size.width - 78, 5, 34, 34);
    self.textField.frame = CGRectMake( 44, 5, self.bounds.size.width - 134, 34);
}

@end
