//
//  LoginPasswordViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/26.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "LoginPasswordViewController.h"
#import "Global.h"
@interface LoginPasswordViewController ()

@end

@implementation LoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"设置登录密码";
    
    //设置登录密码
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,STATUS_NAV_BAR_HEIGHT + 44 , MainWidth, 88)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderWidth = 0.5;
    backView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:backView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, backView.frame.size.height / 2.0, MainWidth - 15, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:lineView];
    
   
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0, 70, 20)];
    numberLabel.font = [UIFont systemFontOfSize:13.0];
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.text = @"输入密码";
    [backView addSubview:numberLabel];
    
    UITextField *numberField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame), 0, 95, 44)];
    numberField.placeholder = @"请输入登录密码";
    numberField.font = [UIFont systemFontOfSize:13.0];
    numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberField.borderStyle = UITextBorderStyleNone;
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:numberField];
    
    UILabel *numberLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberField.frame), 0, 140, 44)];
    numberLevelLabel.font = [UIFont systemFontOfSize:13.0];
    numberLevelLabel.textColor = [UIColor blackColor];
    numberLevelLabel.text = @"密码等级 ：低/中/高";
    [backView addSubview:numberLevelLabel];

    UILabel *verifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0 + 44, 95, 20)];
    verifyLabel.font = [UIFont systemFontOfSize:13.0];
    verifyLabel.textColor = [UIColor blackColor];
    verifyLabel.text = @"再次输入密码";
    [backView addSubview:verifyLabel];
    
    UITextField *verifyField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verifyLabel.frame), 44, MainWidth - numberLabel.frame.size.width - 130, 44)];
    verifyField.placeholder = @"请再次输入密码";
    verifyField.font = [UIFont systemFontOfSize:13.0];
    verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyField.borderStyle = UITextBorderStyleNone;
    [backView addSubview:verifyField];
    
    
    //提交
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.backgroundColor = [UIColor greenColor];
    submitButton.layer.cornerRadius = 2.0;
    submitButton.layer.masksToBounds = YES;
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    submitButton.frame = CGRectMake(10, CGRectGetMaxY(backView.frame) + 20, MainWidth - 10*2.0, 44);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:submitButton];

}


- (void)submitButtonClick{
    
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
