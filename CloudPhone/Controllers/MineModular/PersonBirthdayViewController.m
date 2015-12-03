//
//  PersonBirthdayViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/3.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "PersonBirthdayViewController.h"

#import "Global.h"

@interface PersonBirthdayViewController()
@property (nonatomic, strong)   UITextField *setNameField;

@end

@implementation PersonBirthdayViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"生日";
    
    //返回
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
    //导航栏右按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 44, 44);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UITextField *setNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, STATUS_NAV_BAR_HEIGHT + 20, MainWidth, 44)];
    setNameField.borderStyle = UITextBorderStyleNone;
    setNameField.backgroundColor = [UIColor whiteColor];
    self.setNameField = setNameField;
    [self.view addSubview:setNameField];
}

- (void)saveClick{
    
    NSDictionary *dic = @{@"field":@"birthday",@"fieval":self.setNameField.text};
    [[AirCloudNetAPIManager sharedManager] updateUserOfParams:dic WithBlock:^(id data, NSError *error){
        
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                [_setNameField resignFirstResponder];
                [CustomMBHud customHudWindow:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self popViewController];
                    if (self.modifyBirthBlock) {
                        self.modifyBirthBlock(self.setNameField.text);
                    }
                    
                });
                
            } else {
                DLog(@"******%@",[dic objectForKey:@"msg"]);
                [CustomMBHud customHudWindow:@"修改失败"];
                
            }
        }
        
    }];
    
}


#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
