//
//  SpitTableViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/11.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "SpitTableViewController.h"
#import "Global.h"
@interface SpitTableViewController ()
@property (nonatomic, copy) NSArray *tipsArray;
@end

@implementation SpitTableViewController
- (NSArray *)tipsArray{
    if (!_tipsArray) {
        _tipsArray = @[@"1.断线了",@"2.有杂音",@"3.串线了",@"4.TA听不到声音",@"5.我听不到声音",@"6.TA听见回音",@"7.我听见回音"];
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 43)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"告诉话仔，您遇到了什么问题？";
    label.textColor = [UIColor colorWithHexString:@"#049ff1"];
    label.font = [UIFont systemFontOfSize:20];
    self.tableView.tableHeaderView = label;

}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tipsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = self.tipsArray[indexPath.row];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(MainWidth - 25, 0, 15, 15)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_facecancel"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
    button.selected = NO;
    cell.accessoryView = button;
    return cell;
}



- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
