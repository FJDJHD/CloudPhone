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
#import "CallRecordsModel.h"

#import "AppDelegate.h"
#import "ECDeviceHeaders.h"
#import "DeviceDelegateHelper.h"
#import "DeviceDelegateHelper+VoIP.h"


@interface DialingViewController ()<DialKeyboardDelegate>
@property (nonatomic,strong) DialKeyboard * keyboard;

- (void)releaseCall;
@end

@implementation DialingViewController{
    BOOL isShow;
}

- (DialingViewController *)initWithCallerName:(NSString *)name andCallerNo:(NSString *)phoneNo andVoipNo:(NSString *)voipNo
{
    if (self = [super init])
    {
        self.callerName = name;
        self.callerNo = phoneNo;
        self.voipNo = voipNo;
        hhInt = 0;
        mmInt = 0;
        ssInt = 0;
        isLouder = NO;
        [ [ECDevice sharedInstance].VoIPManager enableLoudsSpeaker:isLouder];
        return self;
    }
    
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDailingUI];
    [self initDialKeyboard];
     isShow = NO;
    
    BOOL isEnableNetWorking = [GeneralToolObject isEnableCurrentNetworkingStatus];
    if (isEnableNetWorking) {
        DLog(@"网络可用,网络电话");
        NSDictionary *dic = @{@"imei":[UniqueUDID shareInstance].udid,@"re_mobile":self.callerNo};
        [[AirCloudNetAPIManager sharedManager] linkRongLianInfoOfParams:dic WithBlock:^(id data, NSError *error){
            if (!error) {
                NSDictionary *dic = (NSDictionary *)data;
                NSDictionary *info = [dic objectForKey:@"data"];
                if ([[dic objectForKey:@"status"] integerValue] == 1) {
                    //网络电话
                    self.sub_account_sid = [info objectForKey:@"sub_account_sid"];
                    self.callID = [[ECDevice sharedInstance].VoIPManager makeCallWithType:VOICE andCalled:self.sub_account_sid];
                    if (self.callID.length <= 0){
                        //获取CallID失败，即拨打失败
                    }
                } else if ([[dic objectForKey:@"status"] integerValue] == 0) {
                    DLog(@"******%@",[dic objectForKey:@"msg"]);
                    //拨打直拨电话
                    dispatch_async(dispatch_get_main_queue(), ^{
                    self.callID =[[ECDevice sharedInstance].VoIPManager makeCallWithType: LandingCall andCalled:self.callerNo];
                    });
                  
                }
            }
        }];
    }else{
        //无网络，应用不可用
    }
    
    if (self.callID.length <= 0) {
        //获取CallID失败，即拨打失败
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCallEvents:) name:KNOTIFICATION_onCallEvent object:nil];
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
    iconImageView.center = CGPointMake(MainWidth / 2.0, iconImageView.frame.size.height / 2.0 + 10);
    [detailView addSubview:iconImageView];
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    nameLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(iconImageView.frame) + 15 + (nameLabel.frame.size.height) / 2.0);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    if (self.callerName) {
        nameLabel.text = self.callerName;
    }else{
        nameLabel.text = @"";
    }
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:nameLabel];
    //电话号码
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    numberLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(nameLabel.frame) + 8 + (numberLabel.frame.size.height) / 2.0);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor lightGrayColor];
    numberLabel.text = self.callerNo;
    numberLabel.font = [UIFont systemFontOfSize:14.0];
    [detailView addSubview:numberLabel];
    //拨打提示
    UILabel *dailingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 15)];
    dailingLabel.center = CGPointMake(MainWidth / 2.0,CGRectGetMaxY(numberLabel.frame) + 8 + (dailingLabel.frame.size.height) / 2.0);
    dailingLabel.textAlignment = NSTextAlignmentCenter;
    dailingLabel.textColor = [UIColor whiteColor];
    dailingLabel.text = @"正在呼叫...";
    dailingLabel.font = [UIFont systemFontOfSize:14.0];
    self.dailingLabel = dailingLabel;
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
            [self handfree];
        }
        break;
            
        case 2:{
            //录音
            DLog(@"2");
        }
        break;
            
        case 3:{
            //回拨
        [self presentViewController:[ItelDialingViewController new] animated:YES completion:nil];
        }
        break;
            
        case 4:{
           //挂断
            if (ssInt > 0) {
                self.callResult = @"0";
            }else{
                self.callResult = @"1";
            }
            [self releaseCall];
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


//处理通话回调事件
- (void)onCallEvents:(NSNotification *)notification {
    
    VoIPCall* voipCall = notification.object;
    if (![self.callID isEqualToString:voipCall.callID]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (voipCall.callStatus){
            case ECallProceeding: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dailingLabel.text = @"呼叫中...";
                });
            }
                break;
                
            case ECallAlerting: {
                [[ECDevice sharedInstance].VoIPManager enableLoudsSpeaker:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dailingLabel.text = @"等待对方接听";
                });
                if (voipCallType!=1){
                }
            }
                break;
                
            case ECallStreaming: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dailingLabel.text = @"00:00";
                });
                
                if (![timer isValid]) {
                    timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateRealtimeLabel) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                    [timer fire];
                }
            }
                break;
                
            case ECallFailed: {
                if( voipCall.reason == ECErrorType_NoResponse) {
                    self.dailingLabel.text = @"网络不给力";
                    self.callResult = @"1";
                    [self releaseCall];

                } else if ( voipCall.reason == ECErrorType_CallBusy || voipCall.reason == ECErrorType_Declined ) {
                    self.dailingLabel.text = @"您拨叫的用户正忙，请稍后再拨";
                    self.callResult = @"1";
                    [self releaseCall];

                } else if ( voipCall.reason == ECErrorType_OtherSideOffline) {
                    self.dailingLabel.text = @"对方不在线,转直拨";
                    //拨打直拨电话
                    self.callID =[[ECDevice sharedInstance].VoIPManager makeCallWithType: LandingCall andCalled:self.callerNo];
                } else if ( voipCall.reason == ECErrorType_CallMissed ) {
                    self.dailingLabel.text = @"呼叫超时";
                    self.callResult = @"1";
                    [self releaseCall];

                } else if ( voipCall.reason == ECErrorType_SDKUnSupport) {
                    self.dailingLabel.text = @"该版本不支持此功能";
                    self.callResult = @"1";
                    [self releaseCall];

                } else if ( voipCall.reason == ECErrorType_CalleeSDKUnSupport ) {
                    self.dailingLabel.text = @"对方版本不支持音频";
                    self.callResult = @"1";
                    [self releaseCall];

                } else {
                    self.dailingLabel.text = @"呼叫失败";
                    self.callResult = @"1";
                    [self releaseCall];
                }
            }
                break;
                
            case ECallEnd: {//呼叫释放
                if ([timer isValid]) {
                    [timer invalidate];
                    timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dailingLabel.text = @"正在挂机...";
                    });
                    self.callResult = @"0";
                    [self releaseCall];
                    
                }
            }
                break;
                
            default:
                break;
        }

    });
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dailingLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hhInt,mmInt,ssInt];
        });

        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
           self.dailingLabel.text = [NSString stringWithFormat:@"%02d:%02d",mmInt,ssInt];
        });

        
    }
}

- (void)releaseCall{
    [[ECDevice sharedInstance].VoIPManager releaseCall:self.callID];
    
    CallRecordsModel *callRecordsModel = [[CallRecordsModel alloc] init];
    callRecordsModel.callResult = self.callResult;
    callRecordsModel.callerName = self.callerName;
    callRecordsModel.callerNo = self.callerNo;
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    callRecordsModel.usercallTime = [NSString stringWithFormat:@"%@",localeDate];
    NSArray *infoArray = [NSArray arrayWithObjects:callRecordsModel.callResult,callRecordsModel.callerName,callRecordsModel.callerNo, callRecordsModel.usercallTime,nil];
    [DBOperate insertDataWithnotAutoID:infoArray tableName:T_callRecords];
    
    NSLog(@"通话记录录入数据库");
    [self presentViewController:[EndDialingViewController new] animated:YES completion:nil];
    
}

- (void)handfree {
    //成功时返回0，失败时返回-1
    NSInteger returnValue = [[ECDevice sharedInstance].VoIPManager enableLoudsSpeaker:!isLouder];
    if (0 == returnValue) {
        isLouder = !isLouder;
    }
}

- (void)dealloc {
    self.callID = nil;
    self.callerName = nil;
    self.callerNo = nil;
    self.voipNo = nil;
    self.dailingLabel = nil;
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
