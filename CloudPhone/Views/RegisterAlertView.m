//
//  RegisterAlertView.m
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "RegisterAlertView.h"
#import "Global.h"
#import "RegisterViewController.h"
#import "LoginPasswordViewController.h"
#import "AppDelegate.h"

#define ALTERTEXTFONT 14
@interface RegisterAlertView()

@property (nonatomic, strong) UIView *backgroudView;

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UIViewController *tempController;

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;


@end

@implementation RegisterAlertView


- (instancetype)initWithFrame:(CGRect)frame lable:(NSString *)str {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
        
        _backgroudView = [[UIView alloc]initWithFrame:frame];
        _backgroudView.backgroundColor = [UIColor blackColor];
        _backgroudView.alpha = 0.6;
        [self addSubview:_backgroudView];
        
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth - 40, 190)];
        _alertView.layer.cornerRadius = 5.0;
        _alertView.layer.masksToBounds = YES;
        _alertView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_alertView];
        
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, _alertView.frame.size.width - 30*2, 80)];
        _label1.numberOfLines = 10;
        _label1.font = [UIFont systemFontOfSize:16.0];
        _label1.textColor = [UIColor blackColor];
        _label1.text = str;
        [_alertView addSubview:_label1];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.backgroundColor = [UIColor lightGrayColor];
        sureButton.layer.cornerRadius = 2.0;
        sureButton.layer.masksToBounds = YES;
        sureButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        sureButton.frame = CGRectMake(30, CGRectGetMaxY(_label1.frame) + 20, _alertView.frame.size.width - 30*2, 40);
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_alertView addSubview:sureButton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame lable1:(NSString *)str1
                       lable2:(NSString *)str2
                       lable3:(NSString *)str3 lable4:(NSString *)str4 {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
        
        _backgroudView = [[UIView alloc]initWithFrame:frame];
        _backgroudView.backgroundColor = [UIColor blackColor];
        _backgroudView.alpha = 0.6;
        [self addSubview:_backgroudView];
        
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainWidth - 40, 300)];
        _alertView.layer.cornerRadius = 5.0;
        _alertView.layer.masksToBounds = YES;
        _alertView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_alertView];
        
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, _alertView.frame.size.width - 30*2, 30)];
        _label1.numberOfLines = 10;
        _label1.font = [UIFont systemFontOfSize:ALTERTEXTFONT];
        _label1.textColor = [UIColor blackColor];
        _label1.text = str1;
        [_alertView addSubview:_label1];
        
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_label1.frame), _alertView.frame.size.width - 30*2, 30)];
        _label2.numberOfLines = 10;
        _label2.font = [UIFont systemFontOfSize:ALTERTEXTFONT];
        _label2.textColor = [UIColor blackColor];
        _label2.text = str2;
        [_alertView addSubview:_label2];
        
        _label3 = [[UILabel alloc]initWithFrame:CGRectMake(70, CGRectGetMaxY(_label2.frame) + 20, _alertView.frame.size.width - 60*2, 50)];
        _label3.numberOfLines = 10;
        _label3.font = [UIFont systemFontOfSize:ALTERTEXTFONT];
        _label3.textColor = [UIColor redColor];
        _label3.text = str3;
        [_alertView addSubview:_label3];
        
        _label4 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_label3.frame) + 20 , _alertView.frame.size.width - 20*2, 30)];
        _label4.numberOfLines = 10;
        _label4.font = [UIFont systemFontOfSize:ALTERTEXTFONT];
        _label4.textColor = [UIColor blackColor];
        _label4.text = str4;
        [_alertView addSubview:_label4];
        
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.backgroundColor = [ColorTool navigationColor];
        sureButton.layer.cornerRadius = 2.0;
        sureButton.layer.masksToBounds = YES;
        sureButton.titleLabel.font = [UIFont systemFontOfSize:ALTERTEXTFONT];
        sureButton.frame = CGRectMake(15, CGRectGetMaxY(_label4.frame) + 20, _alertView.frame.size.width - 15*2, 44);
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_alertView addSubview:sureButton];
    }
    return self;
}


- (void)sureButtonClick {
    if ([self.tempController isKindOfClass:[RegisterViewController class]]) {
        [self dismiss];
        LoginPasswordViewController *passVc = [[LoginPasswordViewController alloc] init];
        [self.tempController.navigationController pushViewController:passVc animated:YES];
        
    }else if ([self.tempController isKindOfClass:[LoginPasswordViewController class]]){
        [self dismiss];
        DLog(@"enter mainVC");
        //这里作为一个登录标志
        [GeneralToolObject userLogin];
    }
}

- (void)show:(UIViewController *)controller {
    
    self.tempController = controller;
    [controller.view addSubview:self];
    
    CGFloat y = SCREEN_HEIGHT + _alertView.bounds.size.height;
    
    _alertView.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), y);
    
    // animation
    [UIView animateWithDuration:0.6
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.9
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _alertView.center = CGPointMake(CGRectGetMidX(self.bounds),
                                                              CGRectGetMidY(self.bounds));
                     } completion:^(BOOL finished) {
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.6f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         float finalY = SCREEN_HEIGHT + _alertView.bounds.size.height;
                         _alertView.center = CGPointMake(_alertView.center.x, finalY);
                         _backgroudView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    
}



@end
