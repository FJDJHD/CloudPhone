//
//  WifiVoipCallViewController.m
//  CloudPhone
//
//  Created by wangcong on 16/1/6.
//  Copyright © 2016年 iTal. All rights reserved.
//

#import "WifiVoipCallViewController.h"
#import "Global.h"
#import "DeviceDelegateHelper.h"
#import "DeviceDelegateHelper+VoIP.h"

@interface WifiVoipCallViewController () {

    int hhInt;
    int mmInt;
    int ssInt;
    NSTimer *timer;
}

@property (nonatomic, copy) NSString *sub_account_sid;
@property (nonatomic, copy) NSString *callID;


@property (nonatomic, strong) UILabel *callerNameLabel;//名字

@property (nonatomic, strong) UILabel *callerNumLabel; //电话

@property (nonatomic, strong) UILabel *connectStatusLabel; //连线状态

@end

@implementation WifiVoipCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCallEvents:) name:KNOTIFICATION_onCallEvent object:nil];
   
    //初始化组件
    [self initGUI];
    
    //网络请求sid才能进行wifi拨号
    [self requestWifiCall];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //免提设置为no
    [[ECDevice sharedInstance].VoIPManager enableLoudsSpeaker:NO];

}

#pragma mark - UI界面 
- (void)initGUI {
    
    //名字
    _callerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainWidth - 200)/2.0, 50.0f, 200.0f, 20.0f)];
    _callerNameLabel.font = [UIFont systemFontOfSize:20.0f];
    _callerNameLabel.textColor = [UIColor whiteColor];
    _callerNameLabel.backgroundColor = [UIColor clearColor];
    _callerNameLabel.textAlignment = NSTextAlignmentCenter;
    _callerNameLabel.text = self.name ? self.name : @"";
    [self.view addSubview:_callerNameLabel];
    
    //电话号码
    _callerNumLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainWidth - 200)/2.0, CGRectGetMaxY(_callerNameLabel.frame) + 10, 200.0f, 20.0f)];
    _callerNumLabel.font = [UIFont systemFontOfSize:18.0f];
    _callerNumLabel.textColor = [UIColor whiteColor];
    _callerNumLabel.backgroundColor = [UIColor clearColor];
    _callerNumLabel.textAlignment = NSTextAlignmentCenter;
    _callerNumLabel.text = self.number ? self.number : @"";
    [self.view addSubview:_callerNumLabel];
    
    //连接状态提示
    _connectStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_callerNumLabel.frame) + 5, MainWidth, 40)];
    _connectStatusLabel.numberOfLines = 2;
    _connectStatusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _connectStatusLabel.text = @"网络正在连接请稍后...";
    _connectStatusLabel.textColor = [UIColor whiteColor];
    _connectStatusLabel.backgroundColor = [UIColor clearColor];
    _connectStatusLabel.textAlignment = NSTextAlignmentCenter;
    _connectStatusLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    [self.view addSubview:_connectStatusLabel];
    
    //挂断电话
    UIButton *hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hangupButton.frame = CGRectMake((MainWidth - 70)/2.0, SCREEN_HEIGHT - 70 - 30, 70, 70);
    hangupButton.layer.cornerRadius = 35;
    hangupButton.layer.masksToBounds = YES;
    hangupButton.backgroundColor = [UIColor redColor];
    [hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
    [hangupButton addTarget:self action:@selector(hangupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hangupButton];
    
}

#pragma mark - 网络请求sid才能进行wifi拨号
- (void)requestWifiCall {
    NSDictionary *dic = @{@"imei":[UniqueUDID shareInstance].udid,@"re_mobile":self.number};
    [[AirCloudNetAPIManager sharedManager] linkRongLianInfoOfParams:dic WithBlock:^(id data, NSError *error){
        if (!error) {
            NSDictionary *dic = (NSDictionary *)data;
            NSDictionary *info = [dic objectForKey:@"data"];
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                //网络WiFi电话
                self.sub_account_sid = [info objectForKey:@"sub_account_sid"];
                self.callID = [[ECDevice sharedInstance].VoIPManager makeCallWithType:VOICE andCalled:self.sub_account_sid];
                
                //获取CallID失败，即拨打失败
                if (self.callID.length <= 0) {
                    DLog(@"对方不在线或网络不给力");
                    _connectStatusLabel.text = @"对方不在线或网络不给力";
                } else {
                    DLog(@"正在等待对方接受邀请......");
                    _connectStatusLabel.text = @"正在等待对方接受邀请......";
                }
                
            } else {
                DLog(@"******%@",[dic objectForKey:@"msg"]);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

//处理通话回调事件
- (void)onCallEvents:(NSNotification *)notification {
    
    VoIPCall* voipCall = notification.object;
    if (![self.callID isEqualToString:voipCall.callID]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (voipCall.callStatus) {
            case ECallProceeding:{
                DLog(@"呼叫中");
                _connectStatusLabel.text = @"呼叫中";
            }
                break;
            case ECallAlerting:{
                DLog(@"等待对方接听");
                _connectStatusLabel.text = @"等待对方接听";
            }
                break;
            case ECallStreaming:{
                [Global shareInstance].isCallBusy = YES;
                DLog(@"正在通话中");
                _connectStatusLabel.text = @"00:00";
                if (![timer isValid]) {
                    timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateRealtimeLabel) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                    [timer fire];
                }
            }
                break;
            case ECallFailed:{
                [Global shareInstance].isCallBusy = NO;
                if( voipCall.reason == ECErrorType_NoResponse) {
                    DLog(@"网络不给力");
                    _connectStatusLabel.text = @"网络不给力";
                } else if ( voipCall.reason == ECErrorType_CallBusy || voipCall.reason == ECErrorType_Declined ) {
                    DLog(@"您拨叫的用户正忙，请稍后再拨");
                    _connectStatusLabel.text = @"您拨叫的用户正忙，请稍后再拨";

                } else if ( voipCall.reason == ECErrorType_OtherSideOffline) {
                    DLog(@"对方不在线");
                    _connectStatusLabel.text = @"对方不在线";

                } else if ( voipCall.reason == ECErrorType_CallMissed ) {
                    DLog(@"呼叫超时");
                    _connectStatusLabel.text = @"呼叫超时";

                } else if ( voipCall.reason == ECErrorType_SDKUnSupport) {
                    DLog(@"该版本不支持此功能");
                    _connectStatusLabel.text = @"该版本不支持此功能";

                } else if ( voipCall.reason == ECErrorType_CalleeSDKUnSupport ) {
                    DLog(@"对方版本不支持音频");
                    _connectStatusLabel.text = @"对方版本不支持音频";

                } else {
                    DLog(@"呼叫失败");
                    _connectStatusLabel.text = @"呼叫失败";

                }
                
         
               [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backFronts) userInfo:nil repeats:NO];
                
            }
                break;
                
            case ECallEnd:{
                DLog(@"挂机了");
                [Global shareInstance].isCallBusy = NO;
                _connectStatusLabel.text = @"正在挂机...";
                [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(backFronts) userInfo:nil repeats:NO];
                
            }
                break;
            case ECallTransfered: {
                DLog(@"呼叫被转移...");
                _connectStatusLabel.text = @"呼叫被转移...";
            }
                break;
                
            default:
                break;
        }
    });
}

#pragma mark - 挂断电话
- (void)hangupButtonClick {
    
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    _connectStatusLabel.text = @"正在挂机...";
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backFronts) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(releaseCall) userInfo:nil repeats:NO];

}


- (void)updateRealtimeLabel {
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
        _connectStatusLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hhInt,mmInt,ssInt];
    } else {
        _connectStatusLabel.text = [NSString stringWithFormat:@"%02d:%02d",mmInt,ssInt];
    }
}

- (void)updateRealTimeStatusLabel {
    _connectStatusLabel.text = @"正在挂机...";
}

- (void)backFronts {
    
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)releaseCall {
    [Global shareInstance].isCallBusy = NO;
    [[ECDevice sharedInstance].VoIPManager releaseCall:self.callID];
}

- (void)dealloc {
   [Global shareInstance].isCallBusy = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
