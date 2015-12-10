//
//  SaveCostViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "SaveCostViewController.h"
#import "Global.h"
@implementation SaveCostViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    //头像
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_savecosticon"]];
    iconImageView.frame = CGRectMake(122, 25, MainWidth - 122 * 2, MainWidth - 122 * 2);
    [self.view addSubview:iconImageView];
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + 18, MainWidth, 15)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = @"刘美兰的云电话";
    nameLabel.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:nameLabel];
    //标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame), MainWidth, 20)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor colorWithHexString:@"#049ff1"];
    titleLable.text = @"省钱记录";
    titleLable.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:titleLable];
    
    UIImageView *savecostImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_savecost"]];
    savecostImageView.frame = CGRectMake(122, 25, MainWidth - 122 * 2, MainWidth - 122 * 2);
    [self.view addSubview:savecostImageView];
    
    UIImageView *calltimeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_calltimeline"]];
    calltimeImageView.frame = CGRectMake(122, 25, MainWidth - 122 * 2, MainWidth - 122 * 2);
    [self.view addSubview:calltimeImageView];

}

@end
