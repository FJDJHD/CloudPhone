//
//  ItelFriendModel.m
//  CloudPhone
//
//  Created by wangcong on 15/12/18.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "ItelFriendModel.h"

@implementation ItelFriendModel

- (instancetype)initWithDic:(NSDictionary *)dic {

    if (self = [super init]) {
        self.userName = [dic objectForKey:@"username"];
        self.mobile = [dic objectForKey:@"mobile"];
    }
    return self;
}

+ (instancetype)modelForData:(NSDictionary *)dic {
    return [[self alloc]initWithDic:dic];
}


@end
