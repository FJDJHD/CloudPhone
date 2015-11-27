//
//  RegisterLoginViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/11/26.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "RegisterLoginViewController.h"
#import "Global.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"


@interface RegisterLoginViewController ()

@end

@implementation RegisterLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome@2x.png"]];
    
    logoImageView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:logoImageView];
    

    
    //登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [ColorTool backgroundColor];
    loginButton.layer.cornerRadius = 2.0;
    loginButton.layer.masksToBounds = YES;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    loginButton.frame = CGRectMake(20, SCREEN_HEIGHT - 200, MainWidth - 20*2.0, 45);
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:[UIColor colorWithHexString:@"#323232"] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
    //注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = [ColorTool backgroundColor];
    registerButton.layer.cornerRadius = 2.0;
    registerButton.layer.masksToBounds = YES;
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    registerButton.frame = CGRectMake(20, CGRectGetMaxY(loginButton.frame) + 25, MainWidth - 20*2.0, 45);
    [registerButton setTitle:@"注 册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitleColor:[UIColor colorWithHexString:@"#323232"] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}


//登录
- (void)loginButtonClick {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];

}


//注册
- (void)registerButtonClick {
    RegisterViewController *controller = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
