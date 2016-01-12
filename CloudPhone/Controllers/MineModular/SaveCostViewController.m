//
//  SaveCostViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "SaveCostViewController.h"
#import "SpitTableViewController.h"
#import "Global.h"
#define LABELX 110
@implementation SaveCostViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"省钱记录";
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    //头像
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_savecosticon"]];
    iconImageView.frame = CGRectMake(122,STATUS_NAV_BAR_HEIGHT + 25, MainWidth - 122 * 2, MainWidth - 122 * 2);
    [self.view addSubview:iconImageView];
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + 18, MainWidth, 15)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = @"刘美兰的云电话";
    nameLabel.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:nameLabel];
    //标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame), MainWidth, 20)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor colorWithHexString:@"#2cceb7"];
    titleLable.text = @"省钱记录";
    titleLable.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:titleLable];
    
    UIImage *savecostImage  = [UIImage imageNamed:@"mine_savecost"];
    UIImageView *savecostImageView = [[UIImageView alloc] initWithImage:savecostImage];
    savecostImageView.frame = CGRectMake(15, CGRectGetMaxY(titleLable.frame), MainWidth - 15 * 2, savecostImage.size.height);
    [self.view addSubview:savecostImageView];

    UILabel *savecostLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABELX, 35, 80, 15)];
    savecostLabel.textAlignment = NSTextAlignmentCenter;
    savecostLabel.textColor = [UIColor blackColor];
    savecostLabel.text = @"节约话费";
    savecostLabel.font = [UIFont systemFontOfSize:12.0];
    [savecostImageView addSubview:savecostLabel];
    
    UILabel *savecostTextLable = [[UILabel alloc] initWithFrame:CGRectMake(LABELX, 50, 80, 20)];
    savecostTextLable.textAlignment = NSTextAlignmentCenter;
    savecostTextLable.textColor = [UIColor colorWithHexString:@"#049ff1"];
    savecostTextLable.text = @"0.4元";
    savecostTextLable.font = [UIFont systemFontOfSize:18.0];
    [savecostImageView addSubview:savecostTextLable];
    
    UIImage *calltimeImage =[UIImage imageNamed:@"mine_calltimeline"];
    UIImageView *calltimeImageView = [[UIImageView alloc] initWithImage:calltimeImage];
    calltimeImageView.frame = CGRectMake(15, CGRectGetMaxY(savecostImageView.frame), MainWidth - 15 * 2, calltimeImage.size.height);
    [self.view addSubview:calltimeImageView];
    
    UILabel *calltimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABELX, 35, 80, 15)];
    calltimeLabel.textAlignment = NSTextAlignmentCenter;
    calltimeLabel.textColor = [UIColor blackColor];
    calltimeLabel.text = @"通话时长";
    calltimeLabel.font = [UIFont systemFontOfSize:13.0];
    [calltimeImageView addSubview:calltimeLabel];
    
    UILabel *calltimeTextLable = [[UILabel alloc] initWithFrame:CGRectMake(LABELX, 50, 80, 20)];
    calltimeTextLable.textAlignment = NSTextAlignmentCenter;
    calltimeTextLable.textColor = [UIColor colorWithHexString:@"#ef7a3a"];
    calltimeTextLable.text = @"2分钟";
    calltimeTextLable.font = [UIFont systemFontOfSize:16.0];
    [calltimeImageView addSubview:calltimeTextLable];
    
    CGRect rect = CGRectMake(44, MainHeight - 10, MainWidth - 44*2.0, 44);
    UIButton *button = [self getButtonWithString:@"把省钱妙方分享给大家" rect:rect taget:self action:@selector(buttonClick) ];
    [self.view addSubview:button];

}

- (UIButton *)getButtonWithString:(NSString *)title rect:(CGRect)rect taget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithHexString:@"#09da61"];
    button.layer.cornerRadius = 2.0;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

- (void)buttonClick{
    [self.navigationController pushViewController:[SpitTableViewController new] animated:YES];
}

- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
