//
//  DialingViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/12/7.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "DialingViewController.h"
#import "Global.h"
#import "DialKeyboard.h"
#import "EndDialingViewController.h"
#import "ItelDialingViewController.h"
@interface DialingViewController ()<DialKeyboardDelegate>
@property (nonatomic,strong) DialKeyboard * keyboard;
@end

@implementation DialingViewController{
    BOOL isShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDailingUI];
    [self initDialKeyboard];
     isShow = NO;
}

- (void)initDialKeyboard{
    //初始化自定义键盘
    CGRect frame = CGRectMake(0, MainHeight - TABBAR_HEIGHT - 30 + 150, MainWidth, 300);
    DialKeyboard * keyboard = [[DialKeyboard alloc] initWithFrame:frame];
    self.keyboard = keyboard;
    self.keyboard.delegate = self;
}

- (void)initDailingUI{
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callphone_bg"]];
    [self.view addSubview:bgView];
    //流量消耗提示
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 15)];
    label.center = CGPointMake(MainWidth / 2.0, (37 + label.frame.size.height) / 2.0);
    label.text = @"每分钟消耗流量300KB";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:label];
    
    //拨打View
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), MainWidth, MainHeight * 0.45)];
    [self.view addSubview:detailView];
    //头像
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callphone_friendiconbg"]];
    iconImageView.frame = CGRectMake(0, 0, MainWidth * 0.3,  MainWidth * 0.3);
    iconImageView.center = CGPointMake(MainWidth / 2.0, iconImageView.frame.size.height / 2.0);
    [detailView addSubview:iconImageView];
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    nameLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(iconImageView.frame) + 25 + (nameLabel.frame.size.height) / 2.0);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"刘美兰";
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:nameLabel];
    //电话号码
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    numberLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(nameLabel.frame) + 8 + (numberLabel.frame.size.height) / 2.0);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor lightGrayColor];
    numberLabel.text = @"13122003325";
    numberLabel.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:numberLabel];
    //拨打提示
    UILabel *dailingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    dailingLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(numberLabel.frame) + 8 + (dailingLabel.frame.size.height) / 2.0);
    dailingLabel.textAlignment = NSTextAlignmentCenter;
    dailingLabel.textColor = [UIColor whiteColor];
    dailingLabel.text = @"正在呼叫...";
    dailingLabel.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:dailingLabel];
    
    //拨打工具栏
    UIView *dailingToolBar= [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailView.frame), MainWidth, MainHeight * 0.6)];
    [self.view addSubview:dailingToolBar];
    NSArray *imageArray = [NSArray array];
    imageArray = @[@"callphone_silence",@"callphone_handsfree",@"callphone_recode",@"callphone_callback",@"callphone_hangup",@"callphone_keyboard"];
    NSArray *nameArray = [NSArray array];
    nameArray = @[@"静音",@"免提",@"录音",@"回拨",@"挂断",@"键盘"];
    
    for (int i = 0; i < 6; i++) {
        int col = i % 3;
        int row = i / 3;
        CGFloat  btWidth = (MainWidth - 32 *2 - 15 * 2) / 3.0;
        CGFloat  btHeight = btWidth;
        CGFloat  btX = 32 + col * (btWidth +15);
        CGFloat  btY = 15 + row * (btWidth + 20 + 20);
        
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
        [self presentViewController:[ItelDialingViewController new] animated:YES completion:nil];
        }
        break;
            
        case 4:{
        [self presentViewController:[EndDialingViewController new] animated:YES completion:nil];
        }
        break;
            
        case 5:{
            if (isShow) {
                [self keyboardHidden];
                }else{
                [self keyboardShow];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma DialKeyboradDelegate
- (void)keyboardShow{
     isShow = !isShow;
    [self.view addSubview:self.keyboard];
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        CGFloat keyboardH = self.keyboard.frame.size.height;
        self.keyboard.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    }];
}

- (void)keyboardHidden{
     isShow = !isShow;
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        CGFloat keyboardH = self.keyboard.frame.size.height;
        self.keyboard.transform = CGAffineTransformMakeTranslation(0,keyboardH);
    }];
}
//点击空白收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isShow == 1) {
        [self keyboardHidden];
    }
}

@end
