//
//  EndDialingViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/29.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "EndDialingViewController.h"
#import "Global.h"
@interface EndDialingViewController ()

@end

@implementation EndDialingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initDailingUI];
}

- (void)initDailingUI{
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callphone_bg"]];
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
    label.center = CGPointMake(MainWidth / 2.0, (35 + label.frame.size.height) / 2.0);
    label.text = @"通话结束，剩余时长127分钟";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:label];
    
    //tips
    UILabel *tipsLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 22)];
    tipsLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(label.frame) + 5 + (tipsLabel.frame.size.height) / 2.0);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor colorWithHexString:@"#646464"];
    tipsLabel.text = @"此次通话由以下品牌免费";
    tipsLabel.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:tipsLabel];

    //品牌图像
    UIImageView *brandImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callphone_friendiconbg"]];
    brandImageView.frame = CGRectMake(0, 0, MainWidth * 0.3,  MainWidth * 0.3);
    brandImageView.center = CGPointMake(MainWidth / 2.0, CGRectGetMaxY(tipsLabel.frame) + 45 + (brandImageView.frame.size.height) / 2.0);
    [self.view addSubview:brandImageView];
    
    //adlabel
    UILabel *adLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
    adLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(brandImageView.frame) + 27 + (adLabel.frame.size.height) / 2.0);
    adLabel.textAlignment = NSTextAlignmentCenter;
    adLabel.textColor = [UIColor whiteColor];
    adLabel.text = @"可视电商第一品牌";
    adLabel.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:adLabel];
    
    //查看按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    button.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(adLabel.frame) + 10 + (button.frame.size.height) / 2.0);
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setTitle:@"立即查看" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    //拨打工具栏
    UIView *dailingToolBar= [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 55, MainWidth, MainHeight * 0.3)];
    [self.view addSubview:dailingToolBar];
    NSArray *imageArray = [NSArray array];
    imageArray = @[@"callphone_silence",@"callphone_handsfree",@"callphone_recode"];
    NSArray *nameArray = [NSArray array];
    nameArray = @[@"重拨",@"关闭",@"吐槽"];
    
    for (int i = 0; i < 3; i++) {
        int col = i % 3;
        CGFloat  btWidth = (MainWidth - 32 *2 - 15 * 2) / 3.0;
        CGFloat  btHeight = btWidth;
        CGFloat  btX = 32 + col * (btWidth +15);
        CGFloat  btY = 15;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(btX, btY, btWidth, btHeight)];
        button.tag = i;
        [button.titleLabel setTextColor:[UIColor whiteColor]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i]]] withTitle:[NSString stringWithFormat:@"%@",nameArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [dailingToolBar addSubview:button];
        
    }
    
}

- (void)clickButton:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            DLog(@"0");
        }
            break;
            
        case 1:{
       [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case 2:{
            DLog(@"2");
        }
            break;
        default:
            break;
    }
    
}


@end