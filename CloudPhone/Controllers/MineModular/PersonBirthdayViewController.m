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
@property (nonatomic, strong)   NSString *setBirthStr;
@end

@implementation PersonBirthdayViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    self.setBirthStr = [[NSString alloc] init];
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"生日";
    
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
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0 , STATUS_NAV_BAR_HEIGHT, MainWidth, 30)];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.text = @"请滚动数字选择日期";
    [self.view addSubview:label];
    
    //日期选择器
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, STATUS_NAV_BAR_HEIGHT + 30, MainWidth, 150);
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate* minDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-366*24*3600*60];
    NSDate* maxDate = [[NSDate alloc]init];
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
}

- (void)dateChange:(UIDatePicker *)datePicker{
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[formatter stringFromDate: datePicker.date];
    self.setBirthStr = dateString;
}

- (void)saveClick{
    
    NSDictionary *dic = @{@"field":@"birthday",@"fieval":self.setBirthStr};
    [[AirCloudNetAPIManager sharedManager] updateUserOfParams:dic WithBlock:^(id data, NSError *error){
        
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                [CustomMBHud customHudWindow:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self popViewController];
                    if (self.modifyBirthBlock) {
                        self.modifyBirthBlock(self.setBirthStr);
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
