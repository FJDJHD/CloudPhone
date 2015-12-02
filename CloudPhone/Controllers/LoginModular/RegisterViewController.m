//
//  RegisterViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/11/26.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "RegisterViewController.h"
#import "Global.h"
#import "LoginPasswordViewController.h"
#import "GeneralToolObject.h"
#import "RegisterAlertView.h"
static const int kTimeCount             = 60;


@interface RegisterViewController ()

@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UITextField *verifyField;
@property (nonatomic, strong) UIButton *proveButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSMutableAttributedString *proveAttStr;

//“获取验证码”的定时器时间
@property (nonatomic, strong) NSTimer *authCodeTimer;
@property (nonatomic, assign) NSInteger timeCount;


@end

@implementation RegisterViewController

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
    
    //返回
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    self.title = @"手机号注册";
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,STATUS_NAV_BAR_HEIGHT + 44, MainWidth, 88)];
    backView.backgroundColor = [UIColor whiteColor];
   
    [self.view addSubview:backView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 44, MainWidth - 15, 1)];
    lineView.backgroundColor = [ColorTool backgroundColor];
    [backView addSubview:lineView];
    
    //手机号
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0, 60, 20)];
    numberLabel.font = [UIFont systemFontOfSize:15.0];
    numberLabel.textColor = [ColorTool textColor];
    numberLabel.text = @"手机号";
    [backView addSubview:numberLabel];
    
    _numberField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame), 0, MainWidth - CGRectGetMaxX(numberLabel.frame), 44)];
    _numberField.placeholder = @"请输入手机号码";
    _numberField.font = [UIFont systemFontOfSize:15.0];
    _numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _numberField.borderStyle = UITextBorderStyleNone;
    _numberField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:_numberField];
    
    //验证码
    UILabel *verifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (44 - 20)/2.0 + 44, 60, 20)];
    verifyLabel.font = [UIFont systemFontOfSize:15.0];
    verifyLabel.textColor = [ColorTool textColor];
    verifyLabel.text = @"验证码";
    [backView addSubview:verifyLabel];

    _verifyField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame), 44, MainWidth - numberLabel.frame.size.width - 130, 44)];
    _verifyField.placeholder = @"请输入短信验证码";
    _verifyField.font = [UIFont systemFontOfSize:15.0];
    _verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyField.borderStyle = UITextBorderStyleNone;
    [backView addSubview:_verifyField];
    
    _proveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _proveButton.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    _proveButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    _proveButton.frame = CGRectMake(CGRectGetMaxX(_verifyField.frame), 44, MainWidth - CGRectGetMaxX(_verifyField.frame), 44);
    
    [_proveButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_proveButton addTarget:self action:@selector(proveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_proveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:_proveButton];
    
    //3分钟内有校
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame) + 10, 150, 12)];
    alertLabel.font = [UIFont systemFontOfSize:13.0];
    alertLabel.textColor = [UIColor colorWithHexString:@"#646464"];
    alertLabel.text = @"验证码3分钟内有效";
    [self.view addSubview:alertLabel];
    
    //注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = [UIColor colorWithHexString:@"049ff1"];
    registerButton.layer.cornerRadius = 2.0;
    registerButton.layer.masksToBounds = YES;
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    registerButton.frame = CGRectMake(15, CGRectGetMaxY(alertLabel.frame) + 10, MainWidth - 15*2.0, 44);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [registerButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    
    //用户协议
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setImage:[UIImage imageNamed:@"chance_"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"chance_selected"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    selectButton.frame = CGRectMake(15, CGRectGetMaxY(registerButton.frame) + 10 , 20, 20);
    [self.view addSubview:selectButton];
    selectButton.selected = YES;
    self.selectButton = selectButton;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(registerButton.frame) + 10, 160, 22)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [UIColor colorWithHexString:@"#8a8a8a"];
    label.text = @"您已经同意iTel云电话的";
    [self.view addSubview:label];

    
    UIButton *customerAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customerAgreementButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    customerAgreementButton.frame = CGRectMake(210, CGRectGetMaxY(registerButton.frame) + 10, 104, 22);
    [customerAgreementButton setTitle:@"《用户许可协议》" forState:UIControlStateNormal];
    [customerAgreementButton addTarget:self action:@selector(customerAgreementClick) forControlEvents:UIControlEventTouchUpInside];
    [customerAgreementButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:customerAgreementButton];
    
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    //界面消失同时判断一下
    [self HUDHidden];
}

//发送验证码
- (void)proveButtonClick {
    if ([GeneralToolObject validateMobile:_numberField.text]) {
        [self startAuthCodeTimmer];
        
        NSDictionary *dic = @{@"mobile":_numberField.text,@"type":@"reg"};
        [[AirCloudNetAPIManager sharedManager] getPhoneNumberVerifyOfParams:dic WithBlock:^(id data, NSError *error) {
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"即将收到短信验证码，请注意查收" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alterView show];
                    
                } else {
                    DLog(@"*****%@",[dic objectForKey:@"msg"]);
                    [CustomMBHud customHudWindow:[dic objectForKey:@"msg"]];
             
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

//注册第一步
- (void)registerButtonClick {
    if (_numberField.text.length == 0) {
        [CustomMBHud customHudWindow:Login_emptyPhoneNumber];
    } else if (_verifyField.text.length == 0) {
        [CustomMBHud customHudWindow:Login_emptyVerifyNumber];
    } else if ([GeneralToolObject validateMobile:_numberField.text]){
        //在这里添加指示器
        [self AddHUD];
        NSDictionary *dic = @{@"mobile":_numberField.text,@"verify":_verifyField.text,@"imei":[GeneralToolObject CPUuidString],@"mobile_model":[[UIDevice currentDevice] model],@"mobile_type":@"iphone",@"reg_terrace":@"iOS",@"reg_id":@"111"};
        [[AirCloudNetAPIManager sharedManager] registerStepOneOfParams:dic WithBlock:^(id data, NSError *error) {
            //隐藏指示器
            [self HUDHidden];
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    [_numberField resignFirstResponder];
                    [_verifyField resignFirstResponder];
                   RegisterAlertView *alertView =[[RegisterAlertView alloc]initWithFrame:self.view.frame lable1:@"您好，云电话账号注册成功 ！" lable2:@"您的手机号就是您的iTel号码了^_^" lable3:@"欢迎您使用iTel云电话 ！尽享免费电话轻松畅聊 ！" lable4:@"为了您的账号安全，请设置登录密码"];
                    [alertView show:self];
                } else {
                
                    [CustomMBHud customHudWindow:[dic objectForKey:@"msg"]];

                }
            }
        }];

    } else {
        [CustomMBHud customHudWindow:Login_sureCorrectNumber];
    }


}

//用户许可协议
- (void)customerAgreementClick{
    
}

//选择用户协议
- (void)selectButtonClick{
//    self.selectButton.selected = !self.selectButton.selected;
    
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


#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
