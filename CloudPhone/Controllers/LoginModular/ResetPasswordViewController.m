//
//  ResetPasswordViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/26.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "Global.h"
#import "RegisterAlertView.h"
#import "RegisterLoginViewController.h"
@interface ResetPasswordViewController ()
@property (nonatomic, strong) UITextField *repasswordField;
@property (nonatomic, strong) UITextField *passwordFiled;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置新登录密码";
    
    //返回
    UIButton *backButton = [self setBackBarButton:0];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];


}

- (void)submitButtonClick{
    
    if (self.passwordFiled.text.length == 0 ) {
        [CustomMBHud customHudWindow:Login_emptyPwdNumber];
    }else if (self.repasswordField.text.length == 0){
        [CustomMBHud customHudWindow:Login_sureEmptyPwdNumber];
    }else if (![self.passwordFiled.text isEqualToString:self.repasswordField.text]){
        [CustomMBHud customHudWindow:Login_noSamePwdNumber];
    }else{
        NSDictionary *dic = @{@"password":self.passwordFiled.text,@"repassword":self.repasswordField.text};
        [[AirCloudNetAPIManager sharedManager] rePasswordOfParams:dic WithBlock:^(id data, NSError *error) {
            
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    
                    UIViewController *controller = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:controller animated:YES];
                } else {
                    DLog(@"******%@",[dic objectForKey:@"msg"]);
                    [CustomMBHud customHudWindow:[NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]]];
                    
                }
            }
            
        }];
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
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
