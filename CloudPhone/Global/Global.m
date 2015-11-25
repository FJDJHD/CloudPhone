//
//  Global.m
//  AirCloud
//
//  Created by mc on 15/3/30.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#import "Global.h"

@implementation Global

+(instancetype)shareInstance {
    static Global *global = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        global = [[Global alloc]init];
    });
    return global;
}

@end
