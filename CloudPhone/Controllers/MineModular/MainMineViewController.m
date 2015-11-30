//
//  MainMineViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MainMineViewController.h"
#import "Global.h"
#import "PersonalViewController.h"
@interface MainMineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSNumber  *remainingTime;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemArray;
@end

@implementation MainMineViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _itemArray = @[@"免费通话时长",@"任务中心",@"关于云电话",@"帮助与反馈",@"设置"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITabvleViewDatasource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        return _itemArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    }
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chance_selected@2x.png"]];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"pic_touxiang@2x.png"];
        cell.textLabel.text = @"mingcehgn";
        cell.detailTextLabel.text = @"00000000";
        
    } else {
        if(indexPath.row == 0){
           cell.detailTextLabel.text = [NSString stringWithFormat:@"剩余%@分钟",self.remainingTime] ;
        }
        cell.textLabel.text = _itemArray[indexPath.row];
    }
    return cell;

}

#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 20;
    } else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 0) {
        return 5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        PersonalViewController *personalViewController = [[PersonalViewController alloc] init];
        [self.navigationController pushViewController:personalViewController animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
