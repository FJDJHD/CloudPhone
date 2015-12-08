//
//  RegisterAlertView.h
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterAlertView : UIView


- (instancetype)initWithFrame:(CGRect)frame lable:(NSString *)str;

//没想到这么蛋疼。。。。。。。model
- (instancetype)initWithFrame:(CGRect)frame lable1:(NSString *)str1
                                            lable2:(NSString *)str2
                                            lable3:(NSString *)str3
                                            lable4:(NSString *)str4
                                            number:(NSString *)num;


- (void)show:(UIViewController *)controller;

@end
