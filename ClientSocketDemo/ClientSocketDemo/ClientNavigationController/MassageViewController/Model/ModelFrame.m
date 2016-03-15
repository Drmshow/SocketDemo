//
//  ModelFrame.m
//  qq聊天界面
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "ModelFrame.h"

@implementation ModelFrame

- (void)setModel:(MYModel *)model
{
    _model = model;
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
    CGRect text = [model.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 170, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    if (model.sameTime) {
        if (model.type) {
            self.iconFrame = CGRectMake(10, 10, 50, 50);
            self.textFrame = CGRectMake(60, 30, text.size.width + 40, text.size.height + 40);
        }else{
            self.iconFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 10, 50, 50);
            self.textFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - text.size.width - 100, 30, text.size.width + 40, text.size.height + 40);
            self.juHuaFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - text.size.width - 120, 50, 20, 20);
        }
    }else{
        self.timeFrame = CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 20);
        if (model.type) {
            self.iconFrame = CGRectMake(10, 40, 50, 50);
            self.textFrame = CGRectMake(60, 60, text.size.width + 40, text.size.height + 40);
        }else{
            self.iconFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 40, 50, 50);
            self.textFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - text.size.width - 100, 60, text.size.width + 40, text.size.height + 40);
            self.juHuaFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - text.size.width - 120, 80, 20, 20);
        }
    }
    
    self.cellHeight = MAX(CGRectGetMaxY(self.iconFrame), CGRectGetMaxY(self.textFrame)) + 10;
}

+ (NSMutableArray *)modelFrames
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayPlist = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        MYModel *model = [MYModel modelWithDict:dict];
        ModelFrame *modelFrame = [[ModelFrame alloc] init];
        ModelFrame *lastModelFrame = [arrayPlist lastObject];
        model.sameTime = [model.time isEqualToString:lastModelFrame.model.time];
        modelFrame.model = model;
        [arrayPlist addObject:modelFrame];
    }
    return arrayPlist;
}

@end
