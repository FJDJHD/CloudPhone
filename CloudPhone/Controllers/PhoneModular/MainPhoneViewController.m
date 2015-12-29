//
//  MainPhoneViewController.m
//  CloudPhone
//
//  Created by wangcong on 15/11/27.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "MainPhoneViewController.h"
#import "Global.h"
#import "AddressViewController.h"
#import "DialingViewController.h"
#import "DailNumberCell.h"
#import "FriendDetailViewController.h"
#import "ItelDialingViewController.h"
#import "DialKeyboard.h"

@interface MainPhoneViewController ()<UITableViewDataSource,UITableViewDelegate,DialKeyboardDelegate,UITextFieldDelegate,UITabBarDelegate>
@property (nonatomic,strong) DialKeyboard * keyboard;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textFiled;
@end

@implementation MainPhoneViewController{
    BOOL isShow;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    //导航栏右按钮
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"phone_friends"];
    addressButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [addressButton setBackgroundImage:image forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addressButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加列表试图
    [self.view addSubview:self.tableView];
    [self initDialKeyboard];
    [self initTextFiled];
}


- (void)initTextFiled{
    UITextField  *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, MainWidth, 44)];
    textFiled.backgroundColor = [UIColor whiteColor];
    self.textFiled = textFiled;
    self.textFiled.delegate = self;
    self.textFiled.inputView  = self.keyboard;
    self.navigationController.navigationBarHidden = YES;
    [self.view insertSubview:self.textFiled aboveSubview:self.navigationController.navigationBar];
   }

- (void)initDialKeyboard{
    //初始化自定义键盘
    CGRect frame = CGRectMake(0, 0, MainWidth, 300);
    DialKeyboard * keyboard = [[DialKeyboard alloc] initWithFrame:frame];
    self.keyboard = keyboard;
    self.keyboard.delegate = self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, STATUS_NAV_BAR_HEIGHT, MainWidth, SCREEN_HEIGHT - TABBAR_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = 60;
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
    DailNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DailNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.dailNameLabel.text = @"刘美兰";
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        DialingViewController *dialingVC = [DialingViewController new];
        [self presentViewController:dialingVC animated:YES completion:nil];
    }else if (indexPath.row == 1){
        FriendDetailViewController *friDetailVC = [FriendDetailViewController new];
        [self.navigationController pushViewController:friDetailVC animated:YES];
    }else{
        [self presentViewController:[ItelDialingViewController new] animated:YES completion:nil];
    }
    
}


- (void)addressButtonClick {
    AddressViewController *controller = [[AddressViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma DialKeyboradDelegate
- (void)keyboardShow{
    isShow = !isShow;
    [self.view addSubview:self.keyboard];
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        CGFloat keyboardH = self.keyboard.frame.size.height;
        self.keyboard.transform = CGAffineTransformMakeTranslation(0, -keyboardH - TABBAR_HEIGHT);
    }];
}

- (void)keyboardHidden{
    isShow = !isShow;
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        CGFloat keyboardH = self.keyboard.frame.size.height;
        self.keyboard.transform = CGAffineTransformMakeTranslation(0,keyboardH + TABBAR_HEIGHT);
    }];
}

- (void)keyboard:(DialKeyboard *)keyboard didClickButton:(UIButton *)button {
    [self.textFiled insertText:button.titleLabel.text];
}

- (void)keyboard:(DialKeyboard *)keyboard didClickDeleteBtn:(UIButton *)deleteBtn {
    [self.textFiled deleteBackward];
}

- (void)keyboard:(DialKeyboard *)keyboard didClickRemoveBtn:(UIButton *)deleteBtn {
    [self.textFiled resignFirstResponder];}

- (void)keyboard:(DialKeyboard *)keyboard didClickDialBtn:(UIButton *)deleteBtn {
    NSLog(@"拨打");
    //这里写拨打电话业务
}

//点击空白收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
        [self.textFiled resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
