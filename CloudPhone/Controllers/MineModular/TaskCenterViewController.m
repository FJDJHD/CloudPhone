//
//  TaskCenterViewController.m
//  CloudPhone
//
//  Created by iTelDeng on 15/11/30.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "TaskCenterViewController.h"
#import "Global.h"

@implementation TaskCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"任务中心";
    //返回
    UIButton *backButton = [self setBackBarButton:1];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    
}


- (void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
