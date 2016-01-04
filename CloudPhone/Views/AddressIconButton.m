//
//  AddressIconButton.m
//  CloudPhone
//
//  Created by wangcong on 15/12/31.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "AddressIconButton.h"
#import "Global.h"

@implementation AddressIconButton


+ (instancetype)buttonWithTitle:(NSString *)title {

    return [[self alloc]initButtonWithTitle:title];
}

- (instancetype)initButtonWithTitle:(NSString *)str {
    AddressIconButton *button = [AddressIconButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 45, 45);
    button.layer.cornerRadius = 45/2.0;
    button.layer.masksToBounds = YES;
    [button setTitle:str forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSInteger r = arc4random() % 180;
    NSInteger g = arc4random() % 180;
    NSInteger b = arc4random() % 180;
    
    [button setBackgroundColor:RGB(r, g, b)];
    
    return button;
}

@end
