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
static const int kTimeCount             = 60;


@interface CallbackPasswordViewController ()
@property (nonatomic, strong) UIButton *proveButton;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UITextField *verifyField;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSMutableAttributedString *proveAttStr;
//“获取验证码”的定时器时间
@property (nonatomic, strong) NSTimer *authCodeTimer;
@property (nonatomic, assign) NSInteger timeCount;
@end

@implementation CallbackPasswordViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _timeCount = kTimeCount;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    
    self.title = @"找回密码";
    
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];


    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(-1,STATUS_NAV_BAR_HEIGHT + 50, MainWidth+2, 88)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderWidth = 0.5;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = [[UIColor colorWithHexString:@"#0abf56"] CGColor];
    [self.view addSubview:backView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 44, MainWidth - 15, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#0abf56"];
    [backView addSubview:lineView];
    
    //手机号
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0, 60, 20)];
    numberLabel.font = [UIFont systemFontOfSize:15.0];
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.text = @"手机号";
    [backView addSubview:numberLabel];
    
    UITextField *numberField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame), 0, MainWidth - CGRectGetMaxX(numberLabel.frame), 44)];
    numberField.placeholder = @"请输入注册手机号码";
    numberField.font = [UIFont systemFontOfSize:15.0];
    numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberField.borderStyle = UITextBorderStyleNone;
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:numberField];
    self.numberField = numberField;
    
    //验证码
    UILabel *verifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0 + 44, 60, 20)];
    verifyLabel.font = [UIFont systemFontOfSize:15.0];
    verifyLabel.textColor = [UIColor blackColor];
    verifyLabel.text = @"验证码";
    [backView addSubview:verifyLabel];
 
    
    UITextField *verifyField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame), 44, MainWidth - numberLabel.frame.size.width - 130, 44)];
    verifyField.placeholder = @"请输入短信验证码";
    verifyField.font = [UIFont systemFontOfSize:15.0];
    verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyField.borderStyle = UITextBorderStyleNone;
    [backView addSubview:verifyField];
    self.verifyField = verifyField;
    
    
    _proveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _proveButton.backgroundColor = [UIColor colorWithHexString:@"#0abf56"];
    _proveButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
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
    registerButton.backgroundColor = [UIColor colorWithHexString:@"#09da61"];
    registerButton.layer.cornerRadius = 2.0;
    registerButton.layer.masksToBounds = YES;
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    registerButton.frame = CGRectMake(15, CGRectGetMaxY(alertLabel.frame) + 10, MainWidth - 15*2.0, 44);
    [registerButton setTitle:@"下一步" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];

}

//发送找回密码验证码
- (void)proveButtonClick {
    if ([GeneralToolObject validateMobile:_numberField.text]) {
        NSDictionary *dic = @{@"mobile":_numberField.text,@"type":@"forget_pwd"};
        [[AirCloudNetAPIManager sharedManager] sendFoundVerifyOfParams:dic WithBlock:^(id data, NSError *error)  {
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    [self startAuthCodeTimmer];
                  UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"即将收到短信验证码，请注意查收" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alterView show];
                    
                } else {
                    [CustomMBHud customHudWindow:[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]]];
                    
                }
            } else {
                //error
                [self originalTimeCountButton]; //再把按钮还原回去
            }
        }];
    } else if (_numberField.text.length == 0){
        [CustomMBHud customHudWindow:Login_emptyPhoneNumber];
    } else {
        [CustomMBHud customHudWindow:Login_sureCorrectNumber];
    }
    
}

//下一步，找回密码提交
- (void)nextButtonClick {
    
    if (_numberField.text.length == 0) {
        [CustomMBHud customHudWindow:Login_emptyPhoneNumber];
    } else if (_verifyField.text.length == 0) {
        [CustomMBHud customHudWindow:Login_emptyVerifyNumber];
    } else if ([GeneralToolObject validateMobile:_numberField.text]){
        //在这里添加指示器
        [self AddHUD];
        NSDictionary *dic = @{@"mobile":self.numberField.text,@"verify_code":self.verifyField.text};
        NSLog(@"%@",self.verifyField.text);
        [[AirCloudNetAPIManager sharedManager] submitFoundPasswordOfParams:dic WithBlock:^(id data, NSError *error) {
            //隐藏指示器
            [self HUDHidden];
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    ResetPasswordViewController *resetPasswordController = [[ResetPasswordViewController alloc] init];
                    resetPasswordController.resetNumber = _numberField.text;
                    [self.navigationController pushViewController:resetPasswordController animated:YES];
                    
                } else {
                     [self originalTimeCountButton]; //再把按钮还原回去
                     [CustomMBHud customHudWindow:[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]]];
                }
            }
        }];
        
    } else {
        [CustomMBHud customHudWindow:Login_sureCorrectNumber];
    }

    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 验证码定时器

- (void)startAuthCodeTimmer
{
    [self timeCountCutButton];
    _authCodeTimer = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(timerFired)userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_authCodeTimer forMode:NSDefaultRunLoopMode];
}

- (void)timerFired {
    //让按钮变成绿色可编辑状态
    NSString *str = [NSString stringWithFormat:@"%ld", --_timeCount];
    [self timeCountCutButton];
    if ([str isEqualToString:@"0"]) {
        [self originalTimeCountButton];
    }
}

//倒计时的button
- (void)timeCountCutButton {
    _proveButton.userInteractionEnabled = NO;
    _proveAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"重新发送(%ld)", _timeCount]];
    
    if (_timeCount>=10) {
        [_proveAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 2)];
    }else{
        [_proveAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 1)];
    }
    
    [_proveButton setAttributedTitle:_proveAttStr forState:UIControlStateNormal];
    
}

//正常时候时的button
- (void)originalTimeCountButton
{
    [_authCodeTimer setFireDate:[NSDate distantFuture]];//关闭定时器
    _proveButton.userInteractionEnabled = YES;
    _proveButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    _proveAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"发送验证码"]];
    [_proveButton setAttributedTitle:_proveAttStr forState:UIControlStateNormal];
    
    _timeCount = kTimeCount;
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



@end
