//
//  PersonalViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "PersonalViewController.h"

#import "Global.h"

@interface PersonalViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation PersonalViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
       
        
    }
    return cell;
}



@end
