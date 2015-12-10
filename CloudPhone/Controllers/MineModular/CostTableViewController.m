//
//  CostTableViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "CostTableViewController.h"
#import "Global.h"
@interface CostTableViewController ()

@end

@implementation CostTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"费用说明";
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}



- (UILabel *)getLabelWithTitle:(NSString *)title color:(UIColor*)color{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (MainWidth - 30)/3.0, 45)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = color;
    return label;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
