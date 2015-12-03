//
//  PersonGenderViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/3.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "PersonGenderViewController.h"
#import "Global.h"

@interface PersonGenderViewController()
@property (nonatomic, strong)   UITextField *setNameField;
@property (nonatomic, strong)  UIButton *selectedButton;
@end

@implementation PersonGenderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"性别";
    
    //返回
    UIButton *backButton = [self setBackBarButton:1];
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
    
    
    
    UIButton *manButton = [UIButton buttonWithType:UIButtonTypeCustom];
    manButton.frame = CGRectMake(5, 200, 50, 44);
    manButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [manButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [manButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [manButton setTitle:@"男" forState:UIControlStateNormal];
    [manButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    manButton.tag = 1;
    [self.view addSubview:manButton];
    
    UIButton *womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    womanButton.frame = CGRectMake(50, 200, 50, 44);
    womanButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [womanButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [womanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [womanButton setTitle:@"女" forState:UIControlStateNormal];
    [womanButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    womanButton.tag = 2;
    [self.view addSubview:womanButton];
    
    UIButton *unsetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unsetButton.frame = CGRectMake(120, 200, 50, 44);
    unsetButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [unsetButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [unsetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [unsetButton setTitle:@"未设置" forState:UIControlStateNormal];
    [unsetButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    unsetButton.tag = 0;
    [self.view addSubview:unsetButton];


}

- (void)ButtonClick:(UIButton *)button{
    self.selectedButton = button;
    NSLog(@"%@",[NSNumber numberWithInteger:self.selectedButton.tag]);
}

- (void)saveClick{
    NSDictionary *dic = @{@"field":@"gender",@"fieval":[NSNumber numberWithInteger:self.selectedButton.tag]};
    [[AirCloudNetAPIManager sharedManager] updateUserOfParams:dic WithBlock:^(id data, NSError *error){
        
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                [_setNameField resignFirstResponder];
                DLog(@"性别修改成功------%@",[dic objectForKey:@"msg"]);
                [CustomMBHud customHudWindow:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self popViewController];
                    if (self.modifyGenderBlock) {
                        self.modifyGenderBlock(self.selectedButton.tag);
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
