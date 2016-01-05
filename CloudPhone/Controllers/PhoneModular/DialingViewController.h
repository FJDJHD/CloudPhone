//
//  DialingViewController.h
//  CloudPhone
//
//  Created by iTelDeng on 15/12/7.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <UIKit/UIKit.h>
#define InComingCall 0  //呼入
#define OutGoingCall 1  //呼出

#define MuteFlagIsMute 1 //静音
#define MuteFlagNotMute 0 //非静音
@interface DialingViewController : UIViewController
{
    int hhInt;
    int mmInt;
    int ssInt;
    NSTimer *timer;
    BOOL isLouder;
    NSInteger voipCallType; //0:直拨 1:免费网络语音通话 2:回拨
}

@property (nonatomic, strong) NSString *callid;
@property (nonatomic, assign) int callDirection;
@property (nonatomic, strong) NSString *callerName;
@property (nonatomic, strong) NSString *callerNo;
@property (nonatomic, strong) NSString *voipNo;

@property (nonatomic, strong) NSString *callID;
@property (nonatomic, strong) NSString *sub_account_sid;

- (DialingViewController *)initWithCallerName:(NSString *)name andCallerNo:(NSString *)phoneNo andVoipNo:(NSString *)voipNo andCallType:(NSInteger)type;

@end
