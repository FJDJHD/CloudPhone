//
//  FreeCallPhoneTimesViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "FreeCallPhoneTimesViewController.h"
#import "Global.h"


@implementation FreeCallPhoneTimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"免费时长";
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
}


- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
