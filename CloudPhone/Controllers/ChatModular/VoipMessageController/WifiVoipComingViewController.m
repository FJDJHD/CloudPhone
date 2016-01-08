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
- (void)initGUI {
    
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
    
    //连接状态提示
    _contactStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contactNumLabel.frame) + 5, MainWidth, 40)];
    _contactStatusLabel.numberOfLines = 2;
    _contactStatusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contactStatusLabel.text = @"正在呼叫...";
    _contactStatusLabel.textColor = [UIColor whiteColor];
    _contactStatusLabel.backgroundColor = [UIColor clearColor];
    _contactStatusLabel.textAlignment = NSTextAlignmentCenter;
    _contactStatusLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    [self.view addSubview:_contactStatusLabel];
    
    //挂断电话
    _hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hangupButton.frame = CGRectMake(50, SCREEN_HEIGHT - 70 - 30, 70, 70);
    _hangupButton.layer.cornerRadius = 35;
    _hangupButton.layer.masksToBounds = YES;
    _hangupButton.backgroundColor = [UIColor redColor];
    [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
    [_hangupButton addTarget:self action:@selector(hangupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hangupButton];
    
    //接听电话
    _anwserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _anwserButton.frame = CGRectMake(MainWidth - 70 - 44, SCREEN_HEIGHT - 70 - 30, 70, 70);
    _anwserButton.layer.cornerRadius = 35;
    _anwserButton.layer.masksToBounds = YES;
    _anwserButton.backgroundColor = [UIColor redColor];
    [_anwserButton setTitle:@"接听" forState:UIControlStateNormal];
    [_anwserButton addTarget:self action:@selector(anwserButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_anwserButton];
    
    
    
}


#pragma mark - 按钮点击
- (void)updateRealtimeLabel
{
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



//接听
- (void)anwserButtonClick {
    
    [UIView animateWithDuration:0.5 animations:^{
        _anwserButton.hidden = YES;
        _hangupButton.frame = CGRectMake((MainWidth - 70)/2.0, SCREEN_HEIGHT - 70 - 30, 70, 70);
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
    NSArray *infoArray = [NSArray arrayWithObjects:callRecordsModel.callResult,callRecordsModel.callerName,callRecordsModel.callerNo, callRecordsModel.usercallTime,nil];
    [DBOperate insertDataWithnotAutoID:infoArray tableName:T_callRecords];

    
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
    NSArray *infoArray = [NSArray arrayWithObjects:callRecordsModel.callResult,callRecordsModel.callerName,callRecordsModel.callerNo, callRecordsModel.usercallTime,nil];
    [DBOperate insertDataWithnotAutoID:infoArray tableName:T_callRecords];

    
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
