//
//  PersonalNameViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/12/2.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "PersonalNameViewController.h"
#import "Global.h"

@implementation PersonalNameViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorTool backgroundColor];
    self.title = @"名字";

    //返回
    UIButton *backButton = [self setBackBarButton];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
}


#pragma mark - nav
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
