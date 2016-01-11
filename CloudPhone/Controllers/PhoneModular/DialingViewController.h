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
    BOOL isMute;
    BOOL isRecord;
    BOOL isShow;
    NSInteger voipCallType; //0:wifi 1:直拨 2:回拨
}

@property (nonatomic, strong) NSString *callID;
@property (nonatomic, assign) int callDirection;
@property (nonatomic, strong) NSString *callerName;
@property (nonatomic, strong) NSString *callerNo;
@property (nonatomic, strong) NSString *voipNo;
@property (nonatomic, strong) NSString *callResult;//0被呼叫方挂机，1，主叫方挂机


@property (nonatomic, strong) NSString *sub_account_sid;


@property (nonatomic,strong) UILabel *dailingLabel;

- (DialingViewController *)initWithCallerName:(NSString *)name andCallerNo:(NSString *)phoneNo andVoipNo:(NSString *)voipNo;

@end
