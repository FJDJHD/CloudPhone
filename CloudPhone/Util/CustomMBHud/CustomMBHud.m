//
//  CustomMBHud.m
//  cloudbox_client_ios
//
//  Created by mc on 15/4/16.
//  Copyright (c) 2015年 mc. All rights reserved.
//

#import "CustomMBHud.h"

@implementation CustomMBHud



+(instancetype)shareInstance {
    static CustomMBHud *instance = nil;
    
    @synchronized(self){
        if (!instance) {
            instance = [[CustomMBHud alloc]init];
        }
    }
    return instance;
}


- (void)customAlert:(NSString *)message {
    _alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil, nil];
    [_alert show];
}


+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)customHudJudgeDisappearController:(UIViewController *)controller seletor:(SEL)method{
    _HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:_HUD];
    
    _HUD.delegate = self;
    _HUD.labelText = @"加载中...";
    [_HUD showWhileExecuting:method onTarget:controller withObject:nil animated:YES];
}

//- (void)customHudJudgeDisappearController:(UIViewController *)controller{
//    _HUD = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
//    _HUD.labelText = @"加载中...";
//}


+ (void)customHudController:(UIViewController *)controller {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

+ (void)customHudController:(UIViewController *)controller withMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
//    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

+ (void)customHudWindow:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)customHudHidden
{
    [_HUD removeFromSuperview];
    _HUD = nil;
}

@end
