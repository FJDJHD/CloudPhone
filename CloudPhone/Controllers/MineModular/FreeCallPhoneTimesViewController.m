//
//  FreeCallPhoneTimesViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "FreeCallPhoneTimesViewController.h"
#import "Global.h"

@interface FreeCallPhoneTimesViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemArray;


@end
@implementation FreeCallPhoneTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"免费时长";
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth,300)];
    
    UIButton *remaineTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(85, 50, MainWidth - 85 * 2 ,MainWidth - 85 * 2)];
    [remaineTimeButton setEnabled:NO];
    UIImage *image = [UIImage imageNamed:@"mine_clock"];
    [remaineTimeButton setBackgroundImage:image forState:UIControlStateDisabled];
    
    UILabel *baseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(remaineTimeButton.frame), 0, 33)];
    baseTimeLabel.text = @"基础时长100分钟/月";
    baseTimeLabel.numberOfLines = 2;

    UILabel *rewardTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(remaineTimeButton.frame), MainWidth / 2.0, 33)];
    rewardTimeLabel.text = @"奖励时长10分钟/月";
    rewardTimeLabel.numberOfLines = 2;
    
    [headerView addSubview:rewardTimeLabel];
    [headerView addSubview:baseTimeLabel];
    [headerView addSubview:baseTimeLabel];
    
    self.tableView.tableHeaderView = headerView;

}

- (NSArray *)itemArray{
    if (!_itemArray) {
        _itemArray = @[@"做任务获取更多免费通话时长",@"费用说明",@"省钱记录"];
    }
    return _itemArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}



- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [ColorTool backgroundColor];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.itemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = self.itemArray[indexPath.row];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    return cell;
}


#pragma mark - UITableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld",indexPath.row);
    
}




- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
