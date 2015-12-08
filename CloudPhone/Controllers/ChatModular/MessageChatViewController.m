//
//  MessageChatViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/12/7.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MessageChatViewController.h"
#import "Global.h"

@interface MessageChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation MessageChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.chatUser ? self.chatUser : @"会话";
    //导航栏返回按钮
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];

     [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITabvleViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }

    cell.textLabel.text = @"fdsf";
    return cell;
}



- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
