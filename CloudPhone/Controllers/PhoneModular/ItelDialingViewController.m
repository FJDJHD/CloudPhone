//
//  ItelDialingViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/11.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "ItelDialingViewController.h"
#import "Global.h"
@interface ItelDialingViewController ()

@end

@implementation ItelDialingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDailingUI];
}

- (void)initDailingUI{
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callphone_bg"]];
    [self.view addSubview:bgView];
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 15)];
    label.center = CGPointMake(MainWidth / 2.0, 37 + (label.frame.size.height) / 2.0);
    label.text = @"专线";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:label];
    
    //connectView
    UIImage *iconImage = [UIImage imageNamed:@"phone_icon"];
    UIImage *coverImage = [UIImage imageNamed:@"phone_iconcover"];
    
    UIView *connectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 16, MainWidth, (MainWidth - 27 * 2 - 65) / 2.0)];
    [self.view addSubview:connectView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    UIImageView *coverIconImageView = [[UIImageView alloc] initWithImage:coverImage];
    iconImageView.frame = CGRectMake(55, 32, iconImage.size.width,  iconImage.size.height);
    coverIconImageView.frame = CGRectMake(0, 0, coverImage.size.width, coverImage.size.height);
    coverIconImageView.center = iconImageView.center;
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    namelabel.center = CGPointMake(coverIconImageView.frame.size.width / 2.0, coverIconImageView.frame.size.height / 2.0);
    namelabel.text = @"刘美兰";
    namelabel.textColor = [UIColor blackColor];
    namelabel.textAlignment = NSTextAlignmentCenter;
    namelabel.font = [UIFont systemFontOfSize:16.0];
    
    [coverIconImageView addSubview:namelabel];
    [connectView addSubview:iconImageView];
    [connectView addSubview:coverIconImageView];
    
    UIImage *pointImage = [UIImage imageNamed:@"phone_point"];
    UIImageView *pointImageView = [[UIImageView alloc] initWithImage:pointImage];
    pointImageView.frame = CGRectMake(0, 0, pointImage.size.width,  pointImage.size.height);
    pointImageView.center = CGPointMake(MainWidth / 2.0, connectView.frame.size.height / 2.0 + 10);
    [connectView addSubview:pointImageView];

    UIImageView *iconImageView2 = [[UIImageView alloc] initWithImage:iconImage];
    UIImageView *coverIconImageView2 = [[UIImageView alloc] initWithImage:coverImage];
    iconImageView2.frame = CGRectMake(MainWidth - 55 - iconImage.size.width, 32, iconImage.size.width,  iconImage.size.height);
    coverIconImageView2.frame = CGRectMake(MainWidth - 55 - iconImage.size.width, 0, coverImage.size.width, coverImage.size.height);
    coverIconImageView2.center = iconImageView2.center;
    
    UILabel *namelabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    namelabel2.center = CGPointMake(coverIconImageView2.frame.size.width / 2.0, coverIconImageView2.frame.size.height / 2.0);
    namelabel2.text = @"小明";
    namelabel2.textColor = [UIColor blackColor];
    namelabel2.textAlignment = NSTextAlignmentCenter;
    namelabel2.font = [UIFont systemFontOfSize:16.0];
    
    [coverIconImageView2 addSubview:namelabel2];
    [connectView addSubview:iconImageView2];
    [connectView addSubview:coverIconImageView2];

    //提示
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth / 1.9, 50)];
    hintLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(connectView.frame) + 25 + (hintLabel.frame.size.height) / 2.0);
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.numberOfLines = 2;
    hintLabel.text = @"艾泰专线正在为您免费呼叫请注意接听专线来电";
    hintLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:hintLabel];
    
    UIImage *buttonBgImage = [UIImage imageNamed:@"phone_itelhangup"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonBgImage.size.width, buttonBgImage.size.height)];
    button.center = CGPointMake(MainWidth / 2.0, CGRectGetMaxY(hintLabel.frame) + buttonBgImage.size.height /2.0  + 58);
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setImage:buttonBgImage withTitle:[NSString stringWithFormat:@"挂断"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
        
    
}

- (void)clickButton:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
