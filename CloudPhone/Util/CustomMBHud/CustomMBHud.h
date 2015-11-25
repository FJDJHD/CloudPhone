//
//  CustomMBHud.h
//  cloudbox_client_ios
//
//  Created by mc on 15/4/16.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

@interface CustomMBHud : NSObject<MBProgressHUDDelegate>{
    
}

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UIAlertView *alert;


+(instancetype)shareInstance;

/* 这里面先封装几个用的着的，方便使用，稍后再补全*/

- (void)customAlert:(NSString *)message;

+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message;

/*这两个用单例使用*/
//.......这个有点问题，暂时不用。。。。。。。。。。
//- (void)customHudJudgeDisappearController:(UIViewController *)controller;
//......这个有点问题，暂时不用。。。。。。。。。。

//根据执行哪个方法判断消失
- (void)customHudJudgeDisappearController:(UIViewController *)controller seletor:(SEL)method;

//移除hud
- (void)customHudHidden;

/****************************************************************************************************/

/*下面的会自动消失*/

//显示在controller上，只显示菊花，哈哈
+ (void)customHudController:(UIViewController *)controller;

//显示在controller上，只显示文字
+ (void)customHudController:(UIViewController *)controller withMessage:(NSString *)message;

//显示在widown上，只显示文字
+ (void)customHudWindow:(NSString *)message;

@end
