//
//  LoginPasswordViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/26.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "LoginPasswordViewController.h"
#import "Global.h"
#import "RegisterAlertView.h"

#define TEXTFONT 15.0
@interface LoginPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *repasswordField;
@property (nonatomic, strong) UITextField *passwordFiled;
@property (nonatomic, strong) NSMutableAttributedString *passwordLevelStr;
@property (nonatomic, strong) UILabel *numberLevelLabel;
@end

@implementation LoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"设置登录密码";
    
    //返回
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //设置登录密码
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,STATUS_NAV_BAR_HEIGHT + 44 , MainWidth, 88)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, backView.frame.size.height / 2.0, MainWidth - 15, 1)];
    lineView.backgroundColor = [ColorTool backgroundColor];
    [backView addSubview:lineView];
    
   
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0, 65, 20)];
    passwordLabel.font = [UIFont systemFontOfSize:TEXTFONT];
    passwordLabel.textColor = [ColorTool textColor];
    passwordLabel.text = @"输入密码";
    [backView addSubview:passwordLabel];
    
    UITextField *passwordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordLabel.frame), 0, 120, 44)];
    passwordField.placeholder = @"请输入密码";
    passwordField.font = [UIFont systemFontOfSize:TEXTFONT];
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordFiled = passwordField;
    self.passwordFiled.delegate = self;
    [backView addSubview:passwordField];
    
    UILabel *numberLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordField.frame) , 0, 140, 44)];
    numberLevelLabel.font = [UIFont systemFontOfSize:14.0];
    numberLevelLabel.textColor = [UIColor blackColor];
    self.numberLevelLabel = numberLevelLabel;
    _passwordLevelStr = [[NSMutableAttributedString alloc] initWithString:@"密码等级:低/中/高"];
    numberLevelLabel.attributedText = _passwordLevelStr;
    [backView addSubview:numberLevelLabel];

    UILabel *verifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0 + 44, 95, 20)];
    verifyLabel.font = [UIFont systemFontOfSize:TEXTFONT];
    verifyLabel.textColor = [UIColor blackColor];
    verifyLabel.text = @"再次输入密码";
    [backView addSubview:verifyLabel];
    
    UITextField *repasswordField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verifyLabel.frame), 44, MainWidth - CGRectGetMaxX(verifyLabel.frame), 44)];
    repasswordField.placeholder = @"请再次输入密码";
    repasswordField.font = [UIFont systemFontOfSize:TEXTFONT];
    repasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    repasswordField.borderStyle = UITextBorderStyleNone;
    self.repasswordField = repasswordField;
    [backView addSubview:repasswordField];
    
    
    //提交
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.backgroundColor = [UIColor colorWithHexString:@"#2b9c31"];
    submitButton.layer.cornerRadius = 2.0;
    submitButton.layer.masksToBounds = YES;
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    submitButton.frame = CGRectMake(10, CGRectGetMaxY(backView.frame) + 20, MainWidth - 10*2.0, 44);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:submitButton];

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length >= 1){
        int result = [GeneralToolObject judgePasswordStrength:toBeString];
        if (result == 0) {
            [self.passwordLevelStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,1)];
            [self.passwordLevelStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(7,1)];
            [self.passwordLevelStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(9,1)];
            }
        else if(result == 1){
            [self.passwordLevelStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(5,1)];
            [self.passwordLevelStr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(7,1)];
            [self.passwordLevelStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(9,1)];
            }
        else if (result==2){
            [self.passwordLevelStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(5,1)];
            [self.passwordLevelStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(7,1)];
            [self.passwordLevelStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(9,1)];
            }
         self.numberLevelLabel.attributedText = _passwordLevelStr;
    }
    return YES;
}



//注册第二步
- (void)submitButtonClick{
    if (self.passwordFiled.text.length == 0 ) {
       [CustomMBHud customHudWindow:Login_emptyPwdNumber];
    }else if (self.repasswordField.text.length == 0){
       [CustomMBHud customHudWindow:Login_sureEmptyPwdNumber];
    }else if (![self.passwordFiled.text isEqualToString:self.repasswordField.text]){
        [CustomMBHud customHudWindow:Login_noSamePwdNumber];
    }else{
        NSDictionary *dic = @{@"password":self.passwordFiled.text,@"repassword":self.repasswordField.text};
        [[AirCloudNetAPIManager sharedManager] registerStepTwoOfParams:dic WithBlock:^(id data, NSError *error) {
            
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    [self.repasswordField resignFirstResponder];
                    [self.repasswordField resignFirstResponder];
                    RegisterAlertView *alertView = [[RegisterAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds lable:@"你好 ！登陆密码已经设置成功，为了你的账号安全，请妥善保管你的密码"];
                    [alertView show:self];
                    
                } else {
                    DLog(@"******%@",[dic objectForKey:@"msg"]);
                    [CustomMBHud customHudWindow:[dic objectForKey:@"msg"]];
                    
                }
            }
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
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
