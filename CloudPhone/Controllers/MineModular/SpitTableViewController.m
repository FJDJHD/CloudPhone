//
//  SpitTableViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/11.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "SpitTableViewController.h"
#import "Global.h"
@interface SpitTableViewController ()<UITextFieldDelegate>
@property (nonatomic, copy) NSArray *tipsArray;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, copy) NSString *string;
@property (nonatomic, strong) NSMutableString *mutableString;
@end

@implementation SpitTableViewController

- (NSArray *)tipsArray{
    if (!_tipsArray) {
        _tipsArray = @[@"1.断线了",@"2.有杂音",@"3.串线了",@"4.TA听不到声音",@"5.我听不到声音",@"6.TA听见回音",@"7.我听见回音",@"其他"];
    }
    return _tipsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.title = @"吐槽";
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    //导航栏右按钮
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, 44, 44);
    editButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [editButton setTitle:@"提交" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 43)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"告诉话仔，您遇到了什么问题？";
    label.textColor = [UIColor colorWithHexString:@"#049ff1"];
    label.font = [UIFont systemFontOfSize:18];
    self.tableView.tableHeaderView = label;
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:panGesture];
    
    self.mutableString = [[NSMutableString alloc]init];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tipsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        if (indexPath.row == 7) {
            self.textFiled = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, MainWidth - 65, 60)];
           self.textFiled.placeholder = @"请输入您的问题";
            self.textFiled.delegate = self;
            [cell addSubview:self.textFiled];
        }else{
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 60)];
        button.tag = indexPath.row;
        UIImage *image = [[UIImage imageNamed:@"phone_spit"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageSelected = [[UIImage imageNamed:@"phone_spit_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, MainWidth * 0.85, 0, 0)];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:imageSelected forState:UIControlStateSelected];
        button.selected = NO;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
      }
    }
    cell.textLabel.text = self.tipsArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//选择吐槽项
- (void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        [_mutableString appendFormat:@"%@,",_tipsArray[btn.tag]];
    }
    if (btn.selected == NO){
        NSRange r1 = [_mutableString rangeOfString:[NSString stringWithFormat:@"%@,",_tipsArray[btn.tag]]];
        [_mutableString deleteCharactersInRange:r1];
    }
    [self.tableView reloadData];
}

//收键盘
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}

- (void)sureClick{
    NSLog(@"%@",self.textFiled.text);
    NSLog(@"%@",_mutableString);
    [self requestPostMock];
}

- (void)requestPostMock {
     NSDictionary *dic = @{@"content_str":_mutableString};
    [[AirCloudNetAPIManager sharedManager] postMockAddOfParams:dic WithBlock:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            
            if (dic) {
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    DLog(@"吐槽成功------%@",[dic objectForKey:@"msg"]);
                } else {
                    DLog(@"******%@",[dic objectForKey:@"msg"]);
                }
            }
        }

    }];

}


- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
