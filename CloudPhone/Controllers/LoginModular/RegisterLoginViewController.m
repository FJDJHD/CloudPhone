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
#import "GuidePageView.h"

@interface RegisterLoginViewController ()

@property (nonatomic,strong) GuidePageView *guideView;


@end

@implementation RegisterLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //读取沙盒数据
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"IsFirstAtVersin: %@", APP_VERSION];
    NSString *value = [setting objectForKey:key];   //value为0表示已经看过引导页了，为空或者其他值是没有看过
    
    if (![value isEqualToString:@"0"]) {            //如果没有数据
        UIImage *imagePage1 = [UIImage imageNamed:@"guide_page_1.png"];
        UIImage *imagePage2 = [UIImage imageNamed:@"guide_page_2.png"];
        UIImage *imagePage3 = [UIImage imageNamed:@"guide_page_3.png"];
        NSArray *imagesArray = [NSArray arrayWithObjects:imagePage1, imagePage2, imagePage3, nil];
        
        if (Is3_5Inches()) {
            _guideView = [[GuidePageView alloc] initWithImages:imagesArray andMargin:[[UIScreen mainScreen] bounds].size.height*0.05];
        } else {
            _guideView = [[GuidePageView alloc] initWithImages:imagesArray];
        }
        
        [_guideView.startButton addTarget:self action:@selector(startButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_guideView];
    } else {
    
        //加载登录界面
        [self initUI];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

#pragma 登录界面
- (void)initUI {
    //添加背景图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgImageView.image = [UIImage imageNamed:@"welcome"];
    [self.view addSubview:bgImageView];
    
    //登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [ColorTool backgroundColor];
    loginButton.layer.cornerRadius = 2.0;
    loginButton.layer.masksToBounds = YES;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    loginButton.frame = CGRectMake(20, SCREEN_HEIGHT * 0.6, MainWidth - 20*2.0, 45);
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:[ColorTool textColor] forState:UIControlStateNormal];
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
    [registerButton setTitleColor:[ColorTool textColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];

}
#pragma mark - 引导页
- (void)startButtonHandle:(UIButton *)sender{
    //写入数据
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"IsFirstAtVersin: %@", APP_VERSION];
    [setting setObject:[NSString stringWithFormat:@"0"] forKey:key];
    [setting synchronize];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _guideView.transform = CGAffineTransformMakeTranslation(-WIDTH(_guideView), 0);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             _guideView.transform = CGAffineTransformIdentity;
                             [_guideView removeFromSuperview];
                             [self initUI];
                         }
                     }];
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
