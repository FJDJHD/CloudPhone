/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#ifndef ChatDemo_UI2_0_DemoErrorCode_h
#define ChatDemo_UI2_0_DemoErrorCode_h

#define EMErrorAudioRecordDurationTooShort -100
#define EMErrorFileTypeConvertionFailure -101
#define EMErrorAudioRecordStoping -102
#define EMErrorAudioRecordNotStarted -103


typedef NS_ENUM(NSInteger, EMErrorType) {
    //general error
    EMErrorNotFound                 = 404,      //不存在
    EMErrorServerMaxCountExceeded   = 500,      //数量达到上限（每人最多100条离线消息，群组成员达到上线）
    
    //configuration error
    EMErrorConfigInvalidAppKey      = 1000,     //无效的appKey
    
    //server error
    EMErrorServerNotLogin           = 1002,     //未登录
    EMErrorServerNotReachable,                  //连接服务器失败(Ex. 手机客户端无网的时候, 会返回的error)
    EMErrorServerTimeout,                       //连接超时(Ex. 服务器连接超时会返回的error)
    EMErrorServerAuthenticationFailure,         //获取token失败(Ex. 登录时用户名密码错误，或者服务器无法返回token)
    EMErrorServerAPNSRegistrationFailure,       //APNS注册失败 (Ex. 登录时, APNS注册失败会返回的error)
    EMErrorServerDuplicatedAccount,             //注册失败(Ex. 注册时, 如果用户存在, 会返回的error)
    EMErrorServerInsufficientPrivilege,         //所执行操作的权限不够(Ex. 非管理员删除群成员时, 会返回的error)
    EMErrorServerTooManyOperations,             //短时间内多次发起同一操作(Ex. 频繁刷新群组列表, 会返回的error)
    
    //file error
    EMErrorAttachmentNotFound,                  //未找着附件
    EMErrorAttachmentUploadFailure,             //文件上传失败
    
    //url error
    EMErrorIllegalURI,                          //URL非法(内部使用)
    
    //message error
    EMErrorMessageInvalid_NULL,                 //无效的消息(为空)
    EMErrorMessageContainSensitiveWords,        //消息中包含敏感词
    
    //group error
    EMErrorGroupInvalidID_NULL,                 //无效的群组ID(为空)
    EMErrorGroupJoined,                         //已加入群组
    EMErrorGroupJoinNeedRequired,               //加入群组需要申请
    EMErrorGroupFetchInfoFailure,               //获取群组失败
    EMErrorGroupInvalidRequired,                //无效的群组申请
    EMErrorGroupInvalidSubject_NULL,            //无效的群主题（为空）
    EMErrorGroupAddOccupantFailure,             //添加群成员失败
    
    //username error
    EMErrorInvalidUsername,                     // 无效的username
    EMErrorInvalidUsername_NULL,                // 无效的用户名(用户名为空)
    EMErrorInvalidUsername_Chinese,             // 无效的用户名(用户名是中文)
    EMErrorInvalidPassword_NULL,                // 无效的密码(密码为空)
    EMErrorInvalidPassword_Chinese,             // 无效的密码(密码是中文)
    
    //apns error
    EMErrorApnsInvalidOption,                   //无效的消息推送设置
    
    //buddy
    EMErrorHasFetchedBuddyList,                 //获取好友列表成功后, 再次发起好友列表请求时返回的errorType
    EMErrorBlockBuddyFailure,                   //将好友加入黑名单失败
    EMErrorUnblockBuddyFailure,                 //将好友从黑名单移出失败
    
    //call error
    EMErrorCallRemoteOffline,                   //对方不在线
    EMErrorCallInvalidId,                       //无效的通话Id
    EMErrorCallConnectFailure,                  //通话连接失败
    
    EMErrorExisted,                             //已存在
    EMErrorInitFailure,                         //初始化失败
    EMErrorNetworkNotConnected,                 //网络未连接
    EMErrorFailure,                             //失败
    EMErrorFeatureNotImplemented,               //还未实现的功能
    EMErrorRequestRefused,                      //申请失效
    
    //chatroom error
    EMErrorChatroomInvalidID_NULL,              //无效的聊天室ID(为空)
    EMErrorChatroomJoined,                      //已加入聊天室
    EMErrorChatroomNotJoined,                   //没有加入聊天室
    
    EMErrorReachLimit = EMErrorServerMaxCountExceeded,
    EMErrorOutOfRateLimited = EMErrorServerMaxCountExceeded,
    EMErrorGroupOccupantsReachLimit = EMErrorServerMaxCountExceeded,
    EMErrorTooManyLoginRequest = EMErrorServerTooManyOperations,
    EMErrorTooManyLogoffRequest = EMErrorServerTooManyOperations,
    EMErrorPermissionFailure = EMErrorServerInsufficientPrivilege,
    EMErrorIsExist = EMErrorExisted,
    EMErrorPushNotificationInvalidOption = EMErrorApnsInvalidOption,
    EMErrorCallChatterOffline = EMErrorCallRemoteOffline,
};


#endif
