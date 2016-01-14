//
//  WifiVoipComingViewController.m
//  CloudPhone
//
//  Created by wangcong on 16/1/6.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import "WifiVoipComingViewController.h"
#import "Global.h"
#import "DeviceDelegateHelper.h"
#import "DeviceDelegateHelper+VoIP.h"
#import "CallRecordsModel.h"


@interface WifiVoipComingViewController () {
    
    int hhInt;
    int mmInt;
    int ssInt;
    NSTimer *timer;
    UIView *dailingToolBar;
    UILabel *dailingLabel;
}

@property (nonatomic, copy) NSString *callID;

@property (nonatomic, copy) NSString *contactName; //名字

@property (nonatomic, copy) NSString *contactNum; //号码

@property (nonatomic, strong) UILabel *contactNameLabel; //打过来的人

@property (nonatomic, strong) UILabel *contactNumLabel; //打过来的号码

@property (nonatomic, strong) UILabel *contactStatusLabel; //接听的状态

@property (nonatomic, strong) UIButton *anwserButton; //接听按钮

@property (nonatomic, strong) UIButton *hangupButton; //挂断按钮

@property (nonatomic, strong) NSString *callResult;


@end

@implementation WifiVoipComingViewController

#pragma mark - init初始化
- (id)initWithName:(NSString *)name andPhoneNO:(NSString *)phoneNO andCallID:(NSString*)callid
{
    self = [super init];
    if (self)
    {
        self.contactName     = name;
        self.callID          = callid;
        self.contactNum  = phoneNO;
        hhInt = 0;
        mmInt = 0;
        ssInt = 0;
        self.status = kIncomingCallStatus_incoming;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCallEvents:) name:KNOTIFICATION_onCallEvent object:nil];
    
    [self initGUI];
    
    
    
}


#pragma mark - UI界面
- (void)initGUIoo {
    
    //名字
    _contactNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainWidth - 200)/2.0, 50.0f, 200.0f, 20.0f)];
    _contactNameLabel.font = [UIFont systemFontOfSize:20.0f];
    _contactNameLabel.textColor = [UIColor whiteColor];
    _contactNameLabel.backgroundColor = [UIColor clearColor];
    _contactNameLabel.textAlignment = NSTextAlignmentCenter;
    _contactNameLabel.text = self.contactName ? self.contactName : @"";
    [self.view addSubview:_contactNameLabel];
    
    //电话号码
    _contactNumLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainWidth - 200)/2.0, CGRectGetMaxY(_contactNameLabel.frame) + 10, 200.0f, 20.0f)];
    _contactNumLabel.font = [UIFont systemFontOfSize:18.0f];
    _contactNumLabel.textColor = [UIColor whiteColor];
    _contactNumLabel.backgroundColor = [UIColor clearColor];
    _contactNumLabel.textAlignment = NSTextAlignmentCenter;
    _contactNumLabel.text = self.contactNum ? self.contactNum : self.contactVoip;
    [self.view addSubview:_contactNumLabel];
    
}

- (void)initGUI{
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
    iconImageView.center = CGPointMake(MainWidth / 2.0, iconImageView.frame.size.height / 2.0 + 10);
    [detailView addSubview:iconImageView];
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    nameLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(iconImageView.frame) + 15 + (nameLabel.frame.size.height) / 2.0);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    if (self.contactName) {
        nameLabel.text = self.contactName ;
    }else{
        nameLabel.text = @"未知号码";
    }
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:nameLabel];
    //电话号码
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    numberLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(nameLabel.frame) + 8 + (numberLabel.frame.size.height) / 2.0);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor lightGrayColor];
    numberLabel.text = self.contactNum;
    numberLabel.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:numberLabel];
    
    //拨打提示
    dailingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    dailingLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(numberLabel.frame) + 8 + (dailingLabel.frame.size.height) / 2.0);
    dailingLabel.textAlignment = NSTextAlignmentCenter;
    dailingLabel.textColor = [UIColor whiteColor];
    dailingLabel.text = @"正在呼叫...";
    dailingLabel.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:dailingLabel];
    
    
    
    //拨打工具栏
    dailingToolBar= [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailView.frame), MainWidth, MainHeight * 0.3)];
    [self.view addSubview:dailingToolBar];
    NSArray *imageArray = [NSArray array];
    imageArray = @[@"callphone_mute",@"callphone_handsfree",@"callphone_record"];
    NSArray *imageSelectedArray = [NSArray array];
    imageSelectedArray = @[@"callphone_mute_sel",@"callphone_handsfree_sel",@"callphone_record_sel"];
    NSArray *nameArray = [NSArray array];
    nameArray = @[@"静音",@"免提",@"录音"];
    
    for (int i = 0; i < 3; i++) {
        int col = i % 3;
        int row = i / 3;
        CGFloat  btWidth = (MainWidth - 32 *2 - 15 * 2) / 3.0;
        CGFloat  btHeight = btWidth;
        CGFloat  btX = 32 + col * (btWidth +15);
        CGFloat  btY = 15 + row * (btWidth + 20 + 20);
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(btX, btY, btWidth, btHeight)];
        button.tag = i;
        button.selected = NO;
        [button.titleLabel setTextColor:[UIColor whiteColor]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i]]] withTitle:[NSString stringWithFormat:@"%@",nameArray[i]] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageSelectedArray[i]]] withTitle:[NSString stringWithFormat:@"%@",nameArray[i]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [dailingToolBar addSubview:button];
    }
    
    //挂断电话
    _hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hangupButton.frame = CGRectMake(32, CGRectGetMaxY(dailingToolBar.frame), 70, 70);
    _hangupButton.layer.cornerRadius = 35;
    _hangupButton.layer.masksToBounds = YES;
    _hangupButton.backgroundColor = [UIColor redColor];
    [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
    [_hangupButton addTarget:self action:@selector(hangupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hangupButton];
    
    //接听电话
    _anwserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _anwserButton.frame = CGRectMake(MainWidth - 32 - 70, CGRectGetMaxY(dailingToolBar.frame), 70, 70);
    _anwserButton.layer.cornerRadius = 35;
    _anwserButton.layer.masksToBounds = YES;
    _anwserButton.backgroundColor = [UIColor greenColor];
    [_anwserButton setTitle:@"接听" forState:UIControlStateNormal];
    [_anwserButton addTarget:self action:@selector(anwserButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_anwserButton];
    
    
}


#pragma mark - 按钮点击
- (void)updateRealtimeLabel{
    ssInt +=1;
    if (ssInt >= 60) {
        mmInt += 1;
        ssInt -= 60;
        if (mmInt >=  60) {
            hhInt += 1;
            mmInt -= 60;
            if (hhInt >= 24) {
                hhInt = 0;
            }
        }
    }
    
    if (hhInt > 0) {
        _contactStatusLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hhInt,mmInt,ssInt];
    } else {
        _contactStatusLabel.text = [NSString stringWithFormat:@"%02d:%02d",mmInt,ssInt];
    }
    //获取网络流量情况，因为需要实时获取，因此需要在定时器里，每隔一段时间获取一次才可以。第一次默认调用是为0
    //    NetworkStatistic *net = [[ECDevice sharedInstance].VoIPManager getNetworkStatisticWithCallId:self.callID];
    //    NSLog(@"NetworkStatistic-%lld_%lld_%lld",net.txBytes_wifi,net.rxBytes_wifi,net.duration);
    //同上
    //    CallStatisticsInfo *info = [[ECDevice sharedInstance].VoIPManager getCallStatisticsWithCallid:self.callID andType:VOICE];
    //    NSLog(@"getCallStatisticsWithCallid-%lu_%lu_%lu",(unsigned long)info.rlBytesSent,(unsigned long)info.rlBytesReceived,(unsigned long)info.rlPacketsReceived);
}

- (void)onCallEvents:(NSNotification *)notification {
    
    VoIPCall* voipCall = notification.object;
    if (![self.callID isEqualToString:voipCall.callID])
    {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (voipCall.callStatus) {
                
            case ECallProceeding:
            {
            }
                break;
                
            case ECallStreaming:
            {
                [[ECDevice sharedInstance].VoIPManager enableLoudsSpeaker:NO];
                _contactStatusLabel.text = @"00:00";
                if (![timer isValid])
                {
                    timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateRealtimeLabel) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                    [timer fire];
                }
            }
                break;
                
            case ECallAlerting:
            {
                DLog(@"ECallAlerting");
                
            }
                break;
                
            case ECallEnd:
            {
                [self releaseCall];
                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(exitView) userInfo:nil repeats:NO];
            }
                break;
                
            case ECallRing:
            {
            }
                break;
                
            case ECallPaused:
            {
                _contactStatusLabel.text = @"呼叫保持...";
            }
                break;
                
            case ECallPausedByRemote:
            {
                _contactStatusLabel.text = @"呼叫被对方保持...";
            }
                break;
                
            case ECallResumed:
            {
                _contactStatusLabel.text = @"呼叫恢复...";
            }
                break;
                
            case ECallResumedByRemote:
            {
                _contactStatusLabel.text = @"呼叫被对方恢复...";
            }
                break;
                
            case ECallTransfered:
            {
                _contactStatusLabel.text = @"呼叫被转移...";
            }
                break;
                
            case ECallFailed:
            {
                [Global shareInstance].isCallBusy = NO;
            }
                break;
                
            default:
                break;
        }
    });
}

- (void)clickButton:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            //静音
            sender.selected = !sender.selected;
            // [self mute];
        }
            break;
            
        case 1:{
            //免提
            sender.selected = !sender.selected;
            // [self handfree];
        }
            break;
            
        case 2:{
            //录音
            sender.selected = !sender.selected;
            // [self startStopRecording];
        }
            break;
        default:
            break;
    }
    
}


//接听
- (void)anwserButtonClick {
    
    [UIView animateWithDuration:0.5 animations:^{
        _anwserButton.hidden = YES;
        _hangupButton.frame = CGRectMake((MainWidth - 70)/2.0, CGRectGetMaxY(dailingToolBar.frame), 70, 70);
    }];
    
    self.status = kIncomingCallStatus_accepting;
    [self refreshView];
}

//挂断
- (void)hangupButtonClick {
    
    [Global shareInstance].isCallBusy = NO;
    [[ECDevice sharedInstance].VoIPManager releaseCall:self.callID];
    
    if (ssInt > 0) {
        self.callResult = @"2";
    }else{
        self.callResult = @"3";
    }
    
    CallRecordsModel *callRecordsModel = [[CallRecordsModel alloc] init];
    callRecordsModel.callResult = self.callResult;
    callRecordsModel.callerName = self.contactName;
    callRecordsModel.callerNo = self.contactNum;
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    callRecordsModel.usercallTime = [NSString stringWithFormat:@"%@",localeDate];
    NSArray *infoArray = [NSArray arrayWithObjects:callRecordsModel.callResult,callRecordsModel.callerNo,callRecordsModel.callerNo, callRecordsModel.usercallTime,nil];
    [DBOperate insertDataWithnotAutoID:infoArray tableName:T_callRecords];
    
    NSArray *callStatisticRecordsArray = [NSArray array];
    callStatisticRecordsArray = [DBOperate queryData:T_callStatisticRecords theColumn:@"callerNo" theColumnValue:self.contactNum withAll:YES];
    if (callStatisticRecordsArray.count > 0) {
        [DBOperate deleteData:T_callStatisticRecords tableColumn:@"callerNo" columnValue:self.contactNum];
        
        [DBOperate insertDataWithnotAutoID:infoArray tableName:T_callStatisticRecords];
        NSLog(@"更新统计通话数据库");
    } else {
        [DBOperate insertDataWithnotAutoID:infoArray tableName:T_callStatisticRecords];
        NSLog(@"新数据统计通话数据库");
    }
    
    [self exitView];
}

- (void)refreshView{
    if (self.status == kIncomingCallStatus_accepting){
        _contactStatusLabel.text = @"正在接听...";
        
        [self performSelector:@selector(answers) withObject:nil afterDelay:0.1];
    }else if (self.status == kIncomingCallStatus_incoming){
        
    }else if(self.status == kIncomingCallStatus_accepted){
        
    }else{
        
    }
}

//接听
- (void)answers {
    [[ECDevice sharedInstance].VoIPManager enableLoudsSpeaker:YES];
    [[ECDevice sharedInstance].VoIPManager acceptCall:self.callID withType:VOICE];
}

//拒绝
- (void)releaseCall{
    [Global shareInstance].isCallBusy = NO;
    [[ECDevice sharedInstance].VoIPManager releaseCall:self.callID];
    
    self.callResult = @"3";
    CallRecordsModel *callRecordsModel = [[CallRecordsModel alloc] init];
    callRecordsModel.callResult = self.callResult;
    callRecordsModel.callerName = self.contactName;
    callRecordsModel.callerNo = self.contactNum;
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    callRecordsModel.usercallTime = [NSString stringWithFormat:@"%@",localeDate];
    NSArray *infoArray = [NSArray arrayWithObjects:callRecordsModel.callResult,callRecordsModel.callerNo,callRecordsModel.callerNo, callRecordsModel.usercallTime,nil];
    [DBOperate insertDataWithnotAutoID:infoArray tableName:T_callRecords];
    
    
    NSArray *callStatisticRecordsArray = [NSArray array];
    callStatisticRecordsArray = [DBOperate queryData:T_callStatisticRecords theColumn:@"callerNo" theColumnValue:self.contactNum withAll:YES];
    if (callStatisticRecordsArray.count > 0) {
        [DBOperate deleteData:T_callStatisticRecords tableColumn:@"callerNo" columnValue:self.contactNum];
        
        [DBOperate insertDataWithnotAutoID:infoArray tableName:T_callStatisticRecords];
        NSLog(@"更新统计通话数据库");
    } else {
        [DBOperate insertDataWithnotAutoID:infoArray tableName:T_callStatisticRecords];
        NSLog(@"新数据统计通话数据库");
    }
}

-(void) exitView {
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
