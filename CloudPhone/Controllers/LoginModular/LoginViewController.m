//
//  LoginViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/26.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "LoginViewController.h"
#import "Global.h"
#import "CallbackPasswordViewController.h"


#define TEXTFONT 15.0
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    
    self.title = @"登录";
    
    //头像
    UIImage *iconImage = [UIImage imageNamed:@"pic_touxiang"];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    iconImageView.center = CGPointMake(MainWidth / 2.0, STATUS_NAV_BAR_HEIGHT + iconImageView.frame.size.height / 2 + 10);
    [self.view addSubview:iconImageView];
   
    //登陆输入
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(iconImageView.frame) + 10, MainWidth, 88)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, backView.frame.size.height / 2.0, MainWidth - 15, 1)];
    lineView.backgroundColor = [ColorTool backgroundColor];
    [backView addSubview:lineView];
    
    //手机号
    UIImageView *numberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0, 20, 20)];
    [numberImageView setImage:[UIImage imageNamed:@"pic_zhanghao"]];
    [backView addSubview:numberImageView];
    
    UITextField *numberField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberImageView.frame) + 10, 0, MainWidth - CGRectGetMaxX(numberImageView.frame), 44)];
    numberField.placeholder = @"请输入手机号码";
    numberField.font = [UIFont systemFontOfSize:TEXTFONT];
    numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberField.borderStyle = UITextBorderStyleNone;
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:numberField];

    //密码
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0 + 44, 20, 20)];
    [passwordImageView setImage:[UIImage imageNamed:@"pic_mima"]];
    [backView addSubview:passwordImageView];
    
    UITextField *passwordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame) + 10, 44, MainWidth - passwordImageView.frame.size.width - 130, 44)];
    passwordField.placeholder = @"请输入登录密码";
    passwordField.font = [UIFont systemFontOfSize:TEXTFONT];
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.borderStyle = UITextBorderStyleNone;
    [backView addSubview:passwordField];
    
    //忘记密码
    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:TEXTFONT];
    forgetPasswordButton.frame = CGRectMake(MainWidth - 15 - 80, CGRectGetMaxY(backView.frame) + 10, 100, 32);
    [forgetPasswordButton setTitle:@"忘记密码 ？" forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [forgetPasswordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:forgetPasswordButton];

    
    //登陆
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [ColorTool navigationColor];
    loginButton.layer.cornerRadius = 2.0;
    loginButton.layer.masksToBounds = YES;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    loginButton.frame = CGRectMake(15, CGRectGetMaxY(forgetPasswordButton.frame), MainWidth - 15*2.0, 44);
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
}

- (void)forgetPasswordButtonClick{
    CallbackPasswordViewController *callbackPasswordController = [[CallbackPasswordViewController alloc] init];
    [self.navigationController pushViewController:callbackPasswordController animated:YES];
}

- (void)loginButtonClick{
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
