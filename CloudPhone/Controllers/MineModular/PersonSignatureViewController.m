
 //
//  PersonSignatureViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/3.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "PersonSignatureViewController.h"


#import "Global.h"

@interface PersonSignatureViewController()<UITextViewDelegate>
@property (nonatomic, strong)   UITextView *setNameView;

@end

@implementation PersonSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"个性签名";
    
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
    //导航栏右按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 44, 44);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveNameClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
   UITextView *setNameView = [[UITextView alloc] initWithFrame:CGRectMake(0, STATUS_NAV_BAR_HEIGHT + 20, MainWidth, 100)];
    setNameView.backgroundColor = [UIColor whiteColor];
    setNameView.font = [UIFont systemFontOfSize:20];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.setNameView = setNameView;
    self.setNameView.delegate = self;
    [self.view addSubview:setNameView];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.setNameView.text = textView.text;
}

- (void)saveNameClick{
    NSDictionary *dic = @{@"field":@"signature",@"fieval":self.setNameView.text};
    [[AirCloudNetAPIManager sharedManager] updateUserOfParams:dic WithBlock:^(id data, NSError *error){
        
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                [_setNameView resignFirstResponder];
                [CustomMBHud customHudWindow:@"个性签名修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self popViewController];
                    if (self.modifySignatureBlock) {
                        self.modifySignatureBlock(self.setNameView.text);
                    }
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *number = [defaults objectForKey:UserNumber];
                    [DBOperate updateData:T_personalInfo tableColumn:@"signature" columnValue:self.setNameView.text conditionColumn:@"phoneNum" conditionColumnValue:number];
                });
                
            } else {
                DLog(@"******%@",[dic objectForKey:@"msg"]);
                [CustomMBHud customHudWindow:@"个性签名修改失败"];
                
                
            }
        }
        
    }];
    
}


#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
