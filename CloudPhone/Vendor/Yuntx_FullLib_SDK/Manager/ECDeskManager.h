//
//  ECDeskManager.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 15/5/18.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import "ECManagerBase.h"
#import "ECError.h"

/**
 *  客服消息
 */
@protocol ECDeskManager <ECManagerBase>
@optional

/**
 @brief  开始和客服聊天
 @param agent      客服账号
 @param completion 执行结果回调block
 */
-(void)startConsultationWithAgent:(NSString*)agent completion:(void(^)(ECError* error, NSString* agent))completion;

/**
 @brief 结束聊天
 @param agent      客服账号
 @param completion 执行结果回调block
 */
-(void)finishConsultationWithAgent:(NSString*)agent completion:(void(^)(ECError* error, NSString* agent))completion;

/**
 @brief  发送消息
 @param message      客服账号
 @param progress   上传进度
 @param completion 执行结果回调block
 */
-(NSString*)sendToDeskMessage:(ECMessage*)message progress:(id<ECProgressDelegate>)progress completion:(void(^)(ECError *error, ECMessage* message))completion;
@required

@end

