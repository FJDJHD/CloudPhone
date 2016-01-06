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

@interface MainPhoneViewController ()<UITableViewDataSource,UITableViewDelegate,DialKeyboardDelegate,UITextFieldDelegate,UITabBarDelegate>{
    BOOL isShow;
    NSMutableString *labelString;
    UIButton *addressButton;
}

@property (nonatomic,strong) DialKeyboard * keyboard;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MainPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isShow = NO;
    labelString = [[NSMutableString alloc]init];
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 20, 44)];
    self.titleLabel.text = @"电话";
                                                               
    
    //导航栏右按钮
    addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
    textFiled.backgroundColor = [ColorTool backgroundColor];
    textFiled.textAlignment = NSTextAlignmentCenter;
    textFiled.enabled = NO;
    self.textFiled = textFiled;
}


- (void)initDialKeyboard{
    //初始化自定义键盘
    CGRect frame = CGRectMake(0, MainHeight - TABBAR_HEIGHT - 30 + 150, MainWidth, 300);
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
    return 2;
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
    
    DialingViewController *dialingVC = [DialingViewController new];
    [self presentViewController:dialingVC animated:YES completion:nil];

//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 1){
//        FriendDetailViewController *friDetailVC = [FriendDetailViewController new];
//        [self.navigationController pushViewController:friDetailVC animated:YES];
//    }
    
}

- (void)addressButtonClick {
    AddressViewController *controller = [[AddressViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma DialKeyboradDelegate
- (void)keyboardShow{
    isShow = !isShow;
    [addressButton setHidden:YES];
    [self.view addSubview:self.keyboard];
    self.navigationItem.titleView = self.textFiled;
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        CGFloat keyboardH = self.keyboard.frame.size.height;
        self.keyboard.transform = CGAffineTransformMakeTranslation(0, -keyboardH - TABBAR_HEIGHT);
    }];
}

- (void)keyboardHidden{
    isShow = !isShow;
    [addressButton setHidden:NO];
    self.navigationItem.titleView = self.titleLabel;
    NSInteger  count = labelString.length;
    NSRange range = {0,count};
    if (count >0) {
        [labelString deleteCharactersInRange:range];
        self.textFiled.text = labelString;
    }
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        CGFloat keyboardH = self.keyboard.frame.size.height;
        self.keyboard.transform = CGAffineTransformMakeTranslation(0,keyboardH + TABBAR_HEIGHT);
    }];
}

- (void)keyboard:(DialKeyboard *)keyboard didClickButton:(UIButton *)button {
    [labelString appendString:button.titleLabel.text];
    self.textFiled.text = labelString;
}

- (void)keyboard:(DialKeyboard *)keyboard didClickDeleteBtn:(UIButton *)deleteBtn {
    NSInteger  count = labelString.length;
    NSRange range = {count - 1,1};
    if (count >0) {
        [labelString deleteCharactersInRange:range];
        self.textFiled.text = labelString;
    }
}

- (void)keyboard:(DialKeyboard *)keyboard didClickRemoveBtn:(UIButton *)deleteBtn {
    [self keyboardHidden];
}

//拨号拨打
- (void)keyboard:(DialKeyboard *)keyboard didClickDialBtn:(UIButton *)deleteBtn {
    //CallType：0 WiFi，1 直拨
    DialingViewController *dialingVC = [[DialingViewController alloc] initWithCallerName:nil andCallerNo:labelString andVoipNo:labelString andCallType:1];
    
    [self presentViewController:dialingVC animated:YES completion:nil];
    [self keyboardHidden];
}

//点击空白收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
       [self keyboardHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
