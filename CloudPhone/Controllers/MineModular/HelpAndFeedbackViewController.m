//
//  HelpAndFeedbackViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "HelpAndFeedbackViewController.h"
#import "Global.h"

@interface HelpAndFeedbackViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *personalDic;
@property (nonatomic, strong) NSMutableArray *helpMutableArray;
@property (nonatomic, strong) NSTextAttachment *attchIcon;


@end


@implementation HelpAndFeedbackViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"帮助与反馈";
    self.helpMutableArray = [NSMutableArray array];


    [self.view addSubview:self.tableView];
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    

    
   [self requestHelpCenterInfo];
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
    if (section == 0) {
        return 1;
    }else{
        return  self.helpMutableArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        if (indexPath.section == 0) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,MainWidth,60)];
            label.font = [UIFont systemFontOfSize:17.0];
            label.text = @"大家都在问的问题哦";
            label.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:label];
        }
        
    }
    
    if (indexPath.section != 0) {
        cell.textLabel.text = [self.helpMutableArray[indexPath.row] objectForKey:@"title"];
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    }
    
    return cell;
}


#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
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
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        NSLog(@"%ld",indexPath.row);
        
    }else {
        NSLog(@"%ld",indexPath.row);
    }
    
}

- (void)requestHelpCenterInfo{
    
    [[AirCloudNetAPIManager sharedManager] getHelpCenterInfoOfParams:nil WithBlock:^(id data, NSError *error){
        
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                DLog(@"------%@",[dic objectForKey:@"msg"]);
                self.helpMutableArray = [dic objectForKey:@"data"];
                [self.tableView reloadData];
            } else {
                DLog(@"******%@",[dic objectForKey:@"msg"]);
                [CustomMBHud customHudWindow:@"数据请求失败"];
                
                
            }
        }
        
    }];
}




#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}



@end