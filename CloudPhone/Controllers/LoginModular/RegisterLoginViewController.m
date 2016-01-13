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
#import "GuidePageView.h"
#import "LoginPasswordViewController.h"
#import "CallbackPasswordViewController.h"
#define TEXTFONT 15.0
@interface RegisterLoginViewController ()

@property (nonatomic,strong) GuidePageView *guideView;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation RegisterLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //读取沙盒数据
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"IsFirstAtVersin: %@", APP_VERSION];
    NSString *value = [setting objectForKey:key];   //value为0表示已经看过引导页了，为空或者其他值是没有看过
    
    if (![value isEqualToString:@"0"]) {            //如果没有数据
        UIImage *imagePage1 = [UIImage imageNamed:@"guide_page_11.png"];
        UIImage *imagePage2 = [UIImage imageNamed:@"guide_page_22.png"];
        UIImage *imagePage3 = [UIImage imageNamed:@"guide_page_33.png"];
        NSArray *imagesArray = [NSArray arrayWithObjects:imagePage1, imagePage2, imagePage3, nil];
        
        if (Is3_5Inches()) {
            _guideView = [[GuidePageView alloc] initWithImages:imagesArray andMargin:[[UIScreen mainScreen] bounds].size.height*0];
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
    bgImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgImageView];
    
    //登陆输入
    UIImage *image = [UIImage imageNamed:@"pic_zhanghao"];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(25,MainHeight * 0.40, MainWidth - 50, 88)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f7f2ee"];
    [self.view addSubview:backView];
    
    //手机号
    UIImageView *numberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (44 - 20)/2.0, 20, 20)];
    [numberImageView setImage:image];
    [backView addSubview:numberImageView];
    
    UITextField *numberField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberImageView.frame) + 15, 0, backView.frame.size.width - numberImageView.frame.size.width - 25, 44)];
    numberField.placeholder = @"请输入手机号码";
    numberField.font = [UIFont systemFontOfSize:TEXTFONT];
    numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberField.borderStyle = UITextBorderStyleNone;
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:numberField];
    self.numberField = numberField;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberImageView.frame) + 10, backView.frame.size.height / 2.0, MainWidth - 75 - image.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [backView addSubview:lineView];
    
    //密码
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (44 - 20)/2.0 + 44, 20, 20)];
    [passwordImageView setImage:[UIImage imageNamed:@"pic_mima"]];
    [backView addSubview:passwordImageView];
    
    UITextField *passwordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame) + 15, 44, backView.frame.size.width - numberImageView.frame.size.width - 25, 44)];
    passwordField.placeholder = @"请输入登录密码";
    passwordField.font = [UIFont systemFontOfSize:TEXTFONT];
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.borderStyle = UITextBorderStyleNone;
    [backView addSubview:passwordField];
    self.passwordField = passwordField;
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame) + 10, backView.frame.size.height, MainWidth - 75 - image.size.width, 1)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [backView addSubview:lineView1];

    
    //忘记密码
    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    forgetPasswordButton.frame = CGRectMake(MainWidth - 40 - 80, CGRectGetMaxY(backView.frame), 100, 32);
    [forgetPasswordButton setTitle:@"忘记密码 ？" forState:UIControlStateNormal];
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [forgetPasswordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:forgetPasswordButton];
        
    //登陆
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [UIColor colorWithHexString:@"#09da61"];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    loginButton.frame = CGRectMake(0, 0, MainWidth - 120, 33);
    loginButton.center = CGPointMake(MainWidth / 2.0, CGRectGetMaxY(backView.frame) + 30 + 25);
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 5.0;
    loginButton.layer.masksToBounds = YES;
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
    //没有账号，注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    registerButton.frame = CGRectMake(0, 0, 200, 32);
    registerButton.center = CGPointMake(MainWidth / 2.0, CGRectGetMaxY(loginButton.frame) + 15 + registerButton.frame.size.height / 2.0);
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"没有账号？立即注册"];
//    NSRange strRange = {0,[str length]};
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//    [registerButton setAttributedTitle:str forState:UIControlStateNormal];
    [registerButton setTitle:@"没有账号？立即注册" forState:UIControlStateNormal];
    registerButton.titleLabel.textColor = [UIColor colorWithHexString:@"#646464"];
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
}

#pragma mark - 引导页
- (void)startButtonHandle:(UIButton *)sender{
    //写入数据
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"IsFirstAtVersin: %@", APP_VERSION];
    [setting setObject:[NSString stringWithFormat:@"0"] forKey:key];
    [setting synchronize];
    
    _guideView.hidden = YES;
    [_guideView removeFromSuperview];
    [self initUI];
    
//    [UIView animateWithDuration:0.3
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _guideView.transform = CGAffineTransformMakeTranslation(-WIDTH(_guideView), 0);
//                     } completion:^(BOOL finished) {
//                         if (finished) {
//                             _guideView.transform = CGAffineTransformIdentity;
//                             [_guideView removeFromSuperview];
//                             [self initUI];
//                         }
//                     }];
}

- (void)forgetPasswordButtonClick{
    CallbackPasswordViewController *callbackPasswordController = [[CallbackPasswordViewController alloc] init];
    [self.navigationController pushViewController:callbackPasswordController animated:YES];
}

//用户登录
- (void)loginButtonClick{
    [_numberField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
    if (self.numberField.text.length == 0 ) {
        [CustomMBHud customHudWindow:Login_emptyPhoneNumber];
    }else if (self.passwordField.text.length == 0){
        [CustomMBHud customHudWindow:Login_emptyPwdNumber];
    }else{
        [self AddHUD];
        NSDictionary *dic = @{@"mobile":self.numberField.text,@"password":self.passwordField.text};
        [[AirCloudNetAPIManager sharedManager] userLoginOfParams:dic WithBlock:^(id data, NSError *error)
         
         {
             [self HUDHidden];
             if (!error) {
                 NSDictionary *dic = (NSDictionary *)data;
                 
                 if ([[dic objectForKey:@"status"] integerValue] == 1) {
                     DLog(@"登录成功------%@",[dic objectForKey:@"msg"]);
                     
                     //保存帐号和密码，做xmpp连接用
                     [GeneralToolObject saveuserNumber:self.numberField.text password:self.passwordField.text];
                     
                     //这里作为一个登录标志
                     [GeneralToolObject userLogin];
                     
                 } else {
                     
                     NSDictionary *dataDic = [dic objectForKey:@"data"];
                     if (dataDic) {
                         if ([dataDic objectForKey:@"is_login"]) {
                             if ([[dataDic objectForKey:@"is_login"] integerValue] == 1) {
                                 
                                 //保存帐号和密码，做xmpp连接用
                                 [GeneralToolObject saveuserNumber:self.numberField.text password:self.passwordField.text];
                                 //登录进去（单独在这里判断下，登录后删除应用情况）
                                 [GeneralToolObject userLogin];
                                 return;
                             }
                         }
                     }
                     [CustomMBHud customHudWindow:[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]]];
                     //                    [[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                     
                 }
             }
             
         }];
        
    }
    
}

//注册
- (void)registerButtonClick {
    RegisterViewController *controller = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - MBProgressHUD Show or Hidden
- (void)AddHUD {
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.labelText = @"请稍后...";
}

- (void)HUDHidden {
    if (_HUD) {
        _HUD.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
