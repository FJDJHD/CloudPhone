//
//  ChatSendHelper.h
//  CloudPhone
//
//  Created by wangcong on 15/12/10.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface ChatSendHelper : NSObject

//发送文字信息
+ (void)sendTextMessageWithString:(NSString *)str toUsername:(NSString *)username;

//发送图片
+ (void)sendImageMessageWithImage:(UIImage *)image toUsername:(XMPPJID *)jid;

//发送语音
+ (void)sendVoiceMessageWithAudio:(NSData *)data time:(NSInteger)duration toUsername:(XMPPJID *)jid;

//发送地理位置
+ (void)sendLocationMessageWithLatitude:(double)lat longitude:(double)lon adress:(NSString *)address toUsername:(XMPPJID *)jid;

//发送好友请求(改成发信息为了和安卓)
+ (void)sendAddFriendMessageWithString:(NSString *)str to:(NSString *)username;

//修改xmpp用户头像
+ (void)modifyUserHeadPortraitWithImage:(UIImage *)image nickName:(NSString *)name;

//修改xmpp用户昵称
+ (void)modifyUserNicknameWithString:(NSString *)str;


//根据jid获取用户头像包括自己的头像
+ (UIImage *)getPhotoWithJID:(XMPPJID *)jid;



@end
