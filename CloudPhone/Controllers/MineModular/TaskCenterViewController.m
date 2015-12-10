//
//  TaskCenterViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "TaskCenterViewController.h"
#import "Global.h"
@interface TaskCenterViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TaskCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"任务中心";
    [self.view addSubview:self.tableView];
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainWidth,140)];
    UIImage *image = [UIImage imageNamed:@"find_adv01"];
    headerView.contentMode = UIViewContentModeCenter;
    headerView.image = image;
    self.tableView.tableHeaderView = headerView;
    

    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        if (indexPath.section == 1 && indexPath.row == 1) {
            NSArray *imageArray = [NSArray array];
            imageArray = @[@"mine_penyouquan",@"mine_qqspace",@"mine_qq",@"mine_weixin"];
            NSArray *nameArray = [NSArray array];
            nameArray = @[@"盆友圈",@"空间",@"QQ",@"微信"];
            
            UIView *shareBar= [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 120)];
            shareBar.backgroundColor = [UIColor whiteColor];
            [cell addSubview:shareBar];
            
            for (int i = 0; i < imageArray.count; i++) {
                int col = i % 2;
                int row = i / 2;
                CGFloat  btWidth = 40;
                CGFloat  btHeight = 40.0;
                CGFloat  btX = col ? MainWidth - 89 - btWidth : 34 - 15;
                CGFloat  btY = 10 + row * (btHeight + 20);
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(btX, btY, btWidth, btHeight);
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i]]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                [shareBar addSubview:button];
            }
        }
    }
     
    
    if (indexPath.section == 0 ) {
    cell.textLabel.text = @"登录签到每次奖励5分钟";
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    } else  if (indexPath.section == 1 && indexPath.row == 0){
    cell.textLabel.text = @"分享云电话，奖励30分钟";
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(MainWidth - 60, 10, 40, 30)];
    label.textColor = [UIColor colorWithHexString:@"#049ff1"];
    label.text = @"说明";
    cell.accessoryView = label;
    }
    return cell;
}



#pragma mark - UITableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 120;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld",indexPath.row);
    
}


- (void)clickButton:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            //静音
            DLog(@"0");
        }
            break;
            
        case 1:{
            //免提
            DLog(@"1");
        }
            break;
            
        case 2:{
            //录音
            DLog(@"2");
        }
            break;
            
        case 3:{
            //回拨
            DLog(@"3");
        }
            break;            
        default:
            break;
    }
    
}

- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
