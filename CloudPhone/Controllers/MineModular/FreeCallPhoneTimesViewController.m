//
//  FreeCallPhoneTimesViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "FreeCallPhoneTimesViewController.h"
#import "Global.h"
#import "SaveCostViewController.h"
#import "CostTableViewController.h"
@interface FreeCallPhoneTimesViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) MBProgressHUD *HUD;


@end
@implementation FreeCallPhoneTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    
    self.title = @"免费时长";
    [self.view addSubview:self.tableView];
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth,300)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIButton *remaineTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(85, 40, MainWidth - 85 * 2 ,MainWidth - 85 * 2)];
    remaineTimeButton.tag = 4000;
    [remaineTimeButton setTitle:@"＊" forState:UIControlStateNormal];
    [remaineTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    remaineTimeButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [remaineTimeButton setEnabled:NO];
    UIImage *image = [UIImage imageNamed:@"mine_clock"];
    [remaineTimeButton setBackgroundImage:image forState:UIControlStateNormal];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(remaineTimeButton.titleLabel.frame) + 10, 100, 20)];
    lable.text = @"剩余分钟数";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:12];
    [remaineTimeButton addSubview:lable];
    
    UILabel *baseTimeLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(remaineTimeButton.frame) + 30, (MainWidth - 40 * 2 ) / 2.0, 25)];
    baseTimeLabel0.text = @"基础时长";
    
    UILabel *baseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(baseTimeLabel0.frame), (MainWidth - 40 * 2 ) / 2.0, 25)];
    baseTimeLabel.tag = 4001;
    baseTimeLabel.text = @"＊分钟";
    
    UILabel *rewardTimeLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth / 2.0 + 20, CGRectGetMaxY(remaineTimeButton.frame) + 30, (MainWidth - 40 * 2 ) / 2.0, 25)];
    rewardTimeLabel0.text = @"奖励时长";
   
    UILabel *rewardTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth / 2.0 + 20, CGRectGetMaxY(rewardTimeLabel0.frame), (MainWidth - 40 * 2 ) / 2.0, 25)];
    rewardTimeLabel.tag = 4002;
    rewardTimeLabel.text = @"＊分钟/月";
    
    [headerView addSubview:remaineTimeButton];
    [headerView addSubview:baseTimeLabel0];
    [headerView addSubview:rewardTimeLabel0];
    [headerView addSubview:baseTimeLabel];
    [headerView addSubview:rewardTimeLabel];
    
    self.tableView.tableHeaderView = headerView;
    
    [self requestPhoneFare];

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
    if (indexPath.row == 2) {
        [self.navigationController pushViewController:[SaveCostViewController new] animated:YES];
    }else if (indexPath.row == 1){
        [self.navigationController pushViewController:[CostTableViewController new] animated:YES];
    }
   
    
}

#pragma mark - 查询话费接口
- (void)requestPhoneFare {
    [self AddHUD];
    [[AirCloudNetAPIManager sharedManager] queryTelphoneFareOfParams:nil WithBlock:^(id data, NSError *error) {
        [self HUDHidden];
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            
            if (dic) {
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    
                    NSDictionary *resultDic = [dic objectForKey:@"data"];
                    //剩余时长
                    NSInteger count_tel_fare = [[resultDic objectForKey:@"count_tel_fare"] integerValue];
                    //基础时长
                    NSInteger give_tel_fare = [[resultDic objectForKey:@"give_tel_fare"] integerValue];
                    //奖励时长
                    NSInteger recharge_tel_fare = [[resultDic objectForKey:@"recharge_tel_fare"] integerValue];
                    
                    //剩余时长
                    UIButton *leaveButton = (UIButton *)[self.view  viewWithTag:4000];
                    [leaveButton setTitle:[NSString stringWithFormat:@"%ld",(long)count_tel_fare] forState:UIControlStateNormal];
                    
                    //基础时长
                    UILabel *baseLabel = (UILabel *)[self.view viewWithTag:4001];
                    baseLabel.text = [NSString stringWithFormat:@"%ld分钟",(long)give_tel_fare];
                    
                    //奖励时长
                    UILabel *rewardLabel = (UILabel *)[self.view viewWithTag:4002];
                    rewardLabel.text = [NSString stringWithFormat:@"%ld分钟/月",(long)recharge_tel_fare];
                    [self.tableView reloadData];
                    
                } else {
                    DLog(@"******%@",[dic objectForKey:@"msg"]);
                    [CustomMBHud customHudWindow:@"请求失败"];
                }
            }
        }
    }];
}

#pragma mark - MBProgressHUD Show or Hidden
- (void)AddHUD {
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.labelText = @"请稍后...";
}

- (void)HUDHidden {
    if (_HUD) {
        _HUD.hidden = YES;
    }
}

- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
