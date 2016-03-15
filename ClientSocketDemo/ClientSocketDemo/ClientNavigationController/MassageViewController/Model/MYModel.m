//
//  MYModel.m
//  qq聊天界面
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import "MYModel.h"

@implementation MYModel

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    MYModel *model = [[MYModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
