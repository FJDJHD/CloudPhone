//
//  PersonalNameViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/12/2.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "PersonalNameViewController.h"
#import "Global.h"

@interface PersonalNameViewController()
@property (nonatomic, strong)   UITextField *setNameField;

@end

@implementation PersonalNameViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"名字";

    //返回
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
    //导航栏右按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 44, 44);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveNameClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    

    UITextField *setNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, STATUS_NAV_BAR_HEIGHT + 20, MainWidth, 44)];
    setNameField.borderStyle = UITextBorderStyleNone;
    setNameField.backgroundColor = [UIColor whiteColor];
    self.setNameField = setNameField;
    [self.view addSubview:setNameField];
}

- (void)saveNameClick{
    [self popViewController];
    
    NSDictionary *dic = @{@"field":@"nick_name",@"fieval":self.setNameField.text};
    [[AirCloudNetAPIManager sharedManager] updateUserOfParams:dic WithBlock:^(id data, NSError *error){
        
         if (!error) {
             NSDictionary *dic = (NSDictionary *)data;
             
             if ([[dic objectForKey:@"status"] integerValue] == 1) {
                 [_setNameField resignFirstResponder];
                 DLog(@"昵称修改成功------%@",[dic objectForKey:@"msg"]);
                 
             } else {
                 DLog(@"******%@",[dic objectForKey:@"msg"]);

                 
             }
         }
         
     }];
    
}


#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
