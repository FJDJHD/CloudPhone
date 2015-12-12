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
@property (nonatomic, copy) NSArray *callStyleArray;
@property (nonatomic, copy) NSArray *friendStyleArray;
@property (nonatomic, copy) NSArray *networkArray;
@property (nonatomic, strong) UILabel *callStyelLabel;
@property (nonatomic, strong) UILabel *friendStyleLabel;
@end

@implementation CostTableViewController

- (NSArray *)callStyleArray{
    if (!_callStyleArray) {
        _callStyleArray = @[@"电话类型",@"网络电话",@"专线电话",@"国际电话",@"国际电话"];
    }
    return _callStyleArray;
}

- (NSArray *)friendStyleArray{
    if (!_friendStyleArray) {
        _friendStyleArray = @[@"对方",@"艾信好友",@"任何手机",@"任何手机",@"任何手机"];
    }
    return _friendStyleArray;
}

- (NSArray *)networkArray{
    if (!_networkArray) {
        _networkArray = @[@"流量",@"免流量",@"WIFI环境",@"WIFI环境",@"WIFI环境"];
    }
    return _networkArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
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

    return self.callStyleArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    if (indexPath.row != self.callStyleArray.count) {
    UILabel *callStyelLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, (MainWidth - 30) / 3.0, 45)];
    callStyelLabel.text = self.callStyleArray[indexPath.row];
    callStyelLabel.textColor = [UIColor colorWithHexString:@"#909090"];
    callStyelLabel.textAlignment = NSTextAlignmentCenter;
    self.callStyelLabel = callStyelLabel;
    [cell addSubview:callStyelLabel];
    
    UILabel *friendStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(callStyelLabel.frame), 0, (MainWidth - 30) / 3.0, 45)];
    friendStyleLabel.text = self.friendStyleArray[indexPath.row];
    friendStyleLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:friendStyleLabel];
        
    UILabel *networkLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(friendStyleLabel.frame), 0, (MainWidth - 30) / 3.0, 45)];
    networkLabel.text = self.networkArray[indexPath.row];
    networkLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:networkLabel];
    }else{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, MainWidth, 45)];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"备注：以上功能全部免费";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
    }
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        self.callStyelLabel.textColor = [UIColor blackColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.row != self.callStyleArray.count) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.callStyelLabel.frame), 0, 1, 45)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.friendStyleLabel.frame), 0, 1, 45)];
        line2.backgroundColor = [UIColor redColor];
        [cell addSubview:line2];
        }

    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.callStyleArray.count) {
        return 90;
    }
    return 45;
}

- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
