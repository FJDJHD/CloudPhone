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
#import "CallRecordsModel.h"
#import "WifiVoipCallViewController.h"

@interface MainPhoneViewController ()<UITableViewDataSource,UITableViewDelegate,DialKeyboardDelegate,UITextFieldDelegate,UITabBarDelegate>{
    BOOL isShow;
    NSMutableString *labelString;
    UIButton *addressButton;
}

@property (nonatomic,strong) DialKeyboard * keyboard;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *infoArray;
@property (nonatomic, strong) CallRecordsModel *callRecordModel;
@property (nonatomic, strong) NSMutableArray *callRecordArray;
@end

@implementation MainPhoneViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
        _infoArray = [DBOperate queryData:T_callStatisticRecords theColumn:nil theColumnValue:nil withAll:YES];
        _infoArray   = (NSMutableArray *)[[_infoArray reverseObjectEnumerator] allObjects];
        self.callRecordArray = [NSMutableArray array];
        if (_infoArray.count > 0) {
            for (NSArray *temp in _infoArray) {
                CallRecordsModel *model = [[CallRecordsModel alloc]init];
                model.callResult = [temp objectAtIndex:record_callResult];
                model.callerName = [temp objectAtIndex:record_callerName];
                model.callerNo = [temp objectAtIndex:record_callerNo];
                model.usercallTime = [temp objectAtIndex:record_callTime];
                model.callerFrequence = [self getCallerFrequence:(NSString *)[temp objectAtIndex:record_callerNo]];
                [self.callRecordArray addObject:model];
            }

        [_tableView reloadData];
    }
}

- (NSInteger *)getCallerFrequence:(NSString *)callerNo{
    _infoArray = [DBOperate queryData:T_callRecords theColumn:@"callerNo" theColumnValue:callerNo withAll:NO];
    return (NSInteger *)_infoArray.count;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGUI];
}

- (void)initGUI {
    isShow = YES;
    labelString = [[NSMutableString alloc]init];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 20, 44)];
    self.titleLabel.text = @"电话";
    self.titleLabel.textColor = [UIColor whiteColor];

    
    //导航栏右按钮
    addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"phone_friends"];
    addressButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [addressButton setBackgroundImage:image forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addressButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    //添加列表试图
    [self.view addSubview:self.tableView];
    [self initDialKeyboard];
    [self initTextFiled];
    [self keyboardShow];
}

- (void)initTextFiled{
    UITextField  *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, MainWidth, 44)];
    textFiled.backgroundColor = [UIColor colorWithHexString:@"#2cceb7"];
    textFiled.font = [UIFont systemFontOfSize:25.0];
    textFiled.textColor = [UIColor whiteColor];
    textFiled.textAlignment = NSTextAlignmentCenter;
    textFiled.enabled = NO;
    self.textFiled = textFiled;
}

- (void)initDialKeyboard{
    //初始化自定义键盘
    CGRect frame = CGRectMake(0, MainHeight - TABBAR_HEIGHT - 30 + 80, MainWidth, 300);
    DialKeyboard * keyboard = [[DialKeyboard alloc] initWithFrame:frame];
    self.keyboard = keyboard;
    self.keyboard.delegate = self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 0, MainWidth, SCREEN_HEIGHT);
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
    return self.callRecordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"cell";
    DailNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DailNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
       
    }

    if (self.callRecordArray.count > 0) {
        CallRecordsModel *model = [self.callRecordArray objectAtIndex:indexPath.row];
        [cell cellForDataWithModel:model indexPath:indexPath controller:self];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CallRecordsModel *model = [self.callRecordArray objectAtIndex:indexPath.row];
    DialingViewController *dialingVC = [[DialingViewController alloc] initWithCallerName:model.callerName andCallerNo:model.callerNo andVoipNo:labelString];
    [self presentViewController:dialingVC animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addressButtonClick {
    AddressViewController *controller = [[AddressViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (isShow == NO) {
//         [self keyboardHidden];
//    }
//   
}


#pragma DialKeyboradDelegate
- (void)keyboardShow{
    isShow = !isShow;
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
    DialingViewController *dialingVC = [[DialingViewController alloc] initWithCallerName:@" " andCallerNo:self.textFiled.text andVoipNo:labelString];
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
