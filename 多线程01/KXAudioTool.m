//
//  KXAudioTool.m
//  多线程01
//
//  Created by zero on 15/3/23.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "KXAudioTool.h"

@interface KXAudioTool ()
@property(nonatomic,strong)NSMutableDictionary *name;

@end

@implementation KXAudioTool

// 定义一份变量
static id _instance;

// 保证只初始化一次
-(id)init
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if((obj = [super init]) != nil)
        {
//            self.name = @[];
        }
    });
    self = obj;
    
    return self;
}
// 保证内存只分配一次
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

// 类方法

 +(id)shareAudioTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

+(id)copyWithZone:(struct _NSZone *)zone
{
    return _instance;
}
@end
