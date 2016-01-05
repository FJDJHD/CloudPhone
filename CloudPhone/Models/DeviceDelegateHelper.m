//
//  DeviceDelegateHelper.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "DeviceDelegateHelper.h"

#define LOG_OPEN 0

@interface DeviceDelegateHelper()
@property(atomic, assign) NSUInteger offlineCount;
@end

@implementation DeviceDelegateHelper{
   
}

+(DeviceDelegateHelper*)sharedInstance{
    static DeviceDelegateHelper *devicedelegatehelper;
    static dispatch_once_t devicedelegatehelperonce;
    dispatch_once(&devicedelegatehelperonce, ^{
        devicedelegatehelper = [[DeviceDelegateHelper alloc] init];
    });
    return devicedelegatehelper;
}


/**链接云通讯服务平台 */
-(void)onConnectState:(ECConnectState)state failed:(ECError*)error {
    switch (state) {
        case State_ConnectSuccess:
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:[ECError errorWithCode:ECErrorType_NoError]];
            break;
        case State_Connecting:
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:[ECError errorWithCode:ECErrorType_Connecting]];
            break;
        case State_ConnectFailed:
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:error];
            break;
        default:
            break;
    }
}


/** 通话功能实现ECVoIPCallDelegate类的回调函数*/

- (NSString*)onIncomingCallReceived:(NSString*)callid withCallerAccount:(NSString *)caller withCallerPhone:(NSString *)callerphone withCallerName:(NSString *)callername withCallType:(CallType)calltype{
    return nil;
}



/**
 
 @brief 呼叫事件
 
 @param voipCall VoIP电话实体类的对象
 
 */

- (void)onCallEvents:(VoIPCall*)voipCall{
    
}


@end
