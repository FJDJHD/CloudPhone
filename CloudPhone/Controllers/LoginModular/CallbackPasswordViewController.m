//
//  CallbackPasswordViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/26.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "CallbackPasswordViewController.h"
#import "Global.h"
#import "ResetPasswordViewController.h"

@interface CallbackPasswordViewController ()
@property (nonatomic, strong) UIButton *proveButton;
@end

@implementation CallbackPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    
    self.title = @"找回密码";
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,STATUS_NAV_BAR_HEIGHT + 30, MainWidth, 88)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 44, MainWidth - 15, 1)];
    lineView.backgroundColor = [ColorTool backgroundColor];
    [backView addSubview:lineView];
    
    //手机号
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0, 60, 20)];
    numberLabel.font = [UIFont systemFontOfSize:15.0];
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.text = @"手机号";
    [backView addSubview:numberLabel];
    
    UITextField *numberField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame), 0, MainWidth - CGRectGetMaxX(numberLabel.frame), 44)];
    numberField.placeholder = @"请输入手机号码";
    numberField.font = [UIFont systemFontOfSize:14.0];
    numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberField.borderStyle = UITextBorderStyleNone;
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:numberField];
    
    //验证码
    UILabel *verifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0 + 44, 60, 20)];
    verifyLabel.font = [UIFont systemFontOfSize:15.0];
    verifyLabel.textColor = [UIColor blackColor];
    verifyLabel.text = @"验证码";
    [backView addSubview:verifyLabel];
    
    UITextField *verifyField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame), 44, MainWidth - numberLabel.frame.size.width - 130, 44)];
    verifyField.placeholder = @"请输入短信验证码";
    verifyField.font = [UIFont systemFontOfSize:14.0];
    verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyField.borderStyle = UITextBorderStyleNone;
    [backView addSubview:verifyField];
    
    _proveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _proveButton.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    _proveButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _proveButton.frame = CGRectMake(CGRectGetMaxX(verifyField.frame), 44, MainWidth - CGRectGetMaxX(verifyField.frame), 44);
    
    [_proveButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_proveButton addTarget:self action:@selector(proveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_proveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:_proveButton];
    
    //3分钟内有校
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame) + 44, 150, 15)];
    alertLabel.font = [UIFont systemFontOfSize:12.0];
    alertLabel.textColor = [UIColor grayColor];
    alertLabel.text = @"验证码3分钟内有效";
    [self.view addSubview:alertLabel];
    
    //下一步
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = appNavgationBackColor;
    registerButton.layer.cornerRadius = 2.0;
    registerButton.layer.masksToBounds = YES;
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    registerButton.frame = CGRectMake(15, CGRectGetMaxY(alertLabel.frame) + 10, MainWidth - 15*2.0, 44);
    [registerButton setTitle:@"下一步" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];

}

//发送验证码
- (void)proveButtonClick {
    
    
}

//下一步
- (void)nextButtonClick {
    ResetPasswordViewController *resetPasswordController = [[ResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:resetPasswordController animated:YES];
    
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
