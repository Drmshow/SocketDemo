
//  MYModel.h
//  qq聊天界面
//
//  Created by drmshow on 16/3/12.
//  Copyright (c) 2016年 drmshow. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MYModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int receivedMassage;

@property (nonatomic, assign) BOOL sameTime;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
